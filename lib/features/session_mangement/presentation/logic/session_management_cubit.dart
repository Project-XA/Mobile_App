import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';

class SessionMangementCubit extends Cubit<SessionManagementState> {
  final CreateSessionUseCase createSessionUseCase;
  final StartSessionServerUseCase startSessionServerUseCase;
  final EndSessionUseCase endSessionUseCase;
  final ListenAttendanceUseCase listenAttendanceUseCase;

  StreamSubscription<AttendanceRecord>? _attendanceSubscription;
  Timer? _sessionTimer;
  Timer? _warningTimer;

  SessionMangementCubit({
    required this.createSessionUseCase,
    required this.startSessionServerUseCase,
    required this.endSessionUseCase,
    required this.listenAttendanceUseCase,
  }) : super(const SessionManagementInitial());

  Future<void> loadStats() async {
    try {
      emit(const SessionManagementLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const SessionManagementIdle());
    } catch (e) {
      emit(SessionManagementError('Failed to load: $e'));
    }
  }

  void changeTab(int index) {
    final currentState = state;

    if (currentState is SessionManagementIdle) {
      emit(currentState.copyWith(selectedTabIndex: index));
    } else if (currentState is SessionState) {
      emit(currentState.copyWith(selectedTabIndex: index));
    }
  }

  Future<void> createAndStartSession({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
    required double allowedRadius,
  }) async {
    final currentState = state;
    if (currentState is! SessionManagementStateWithTab) return;

    try {
      await _createSession(
        name: name,
        location: location,
        connectionMethod: connectionMethod,
        startTime: startTime,
        durationMinutes: durationMinutes,
        allowedRadius: allowedRadius,
        selectedTabIndex: currentState.selectedTabIndex,
      );

      await _startServer(currentState.selectedTabIndex);
    } on ApiErrorModel catch (error) {
      _handleSessionError(error, currentState.selectedTabIndex); 
    } catch (e) {
      _handleSessionError(
        const ApiErrorModel( 
          message: 'An unexpected error occurred',
          type: ApiErrorType.unknown,
          statusCode: 500,
        ),
        currentState.selectedTabIndex,
      );
    }
  }


  Future<void> _createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
    required double allowedRadius,
    required int selectedTabIndex,
  }) async {
    final now = DateTime.now();
    final sessionStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    final placeholderSession = Session(
      id: 0,
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: sessionStartTime,
      durationMinutes: durationMinutes,
      status: SessionStatus.inactive,
      connectedClients: 0,
      attendanceList: [],
    );

    emit(
      SessionState(
        session: placeholderSession,
        operation: SessionOperation.creating,
        selectedTabIndex: selectedTabIndex,
      ),
    );

    final session = await createSessionUseCase(
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: sessionStartTime,
      durationMinutes: durationMinutes,
      allowedRadius: allowedRadius,
    );

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      SessionState(
        session: session,
        operation: SessionOperation.starting,
        selectedTabIndex: selectedTabIndex,
      ),
    );
  }

  Future<void> _startServer(int selectedTabIndex) async {
    final currentState = state;
    if (currentState is! SessionState) return;

    final serverInfo = await startSessionServerUseCase(currentState.session.id);

    _listenToAttendance(currentState.session, serverInfo, selectedTabIndex);

    final activeSession = currentState.session.copyWith(
      status: SessionStatus.active,
    );

    emit(
      SessionState(
        session: activeSession,
        operation: SessionOperation.active,
        serverInfo: serverInfo,
        selectedTabIndex: selectedTabIndex,
      ),
    );

    _startSessionTimer(activeSession);
  }

  void _startSessionTimer(Session session) {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();

    final endTime = session.startTime.add(
      Duration(minutes: session.durationMinutes),
    );
    final timeUntilEnd = endTime.difference(DateTime.now());

    if (timeUntilEnd.isNegative) {
      _autoEndSession();
      return;
    }

    _sessionTimer = Timer(timeUntilEnd, () {
      debugPrint('⏰ Session time expired - Auto ending session');
      _autoEndSession();
    });

    final warningTime = timeUntilEnd - const Duration(minutes: 5);
    if (warningTime.isNegative) {
      _showWarning();
    } else {
      _warningTimer = Timer(warningTime, () {
        debugPrint('⚠️ 5 minutes remaining - Showing warning');
        _showWarning();
      });
    }
  }

  void _showWarning() {
    final currentState = state;
    if (currentState is! SessionState) return;

    emit(currentState.copyWith(showWarning: true));

    Future.delayed(const Duration(seconds: 5), () {
      final state = this.state;
      if (state is SessionState && state.showWarning) {
        emit(state.copyWith(showWarning: false));
      }
    });
  }

  Future<void> _autoEndSession() async {
    final currentState = state;
    if (currentState is! SessionState) return;

    debugPrint('🔴 Auto-ending session: ${currentState.session.name}');

    try {
      await endSession();
    } catch (e) {
      debugPrint('❌ Error auto-ending session: $e');
    }
  }

  void _listenToAttendance(
    Session session,
    ServerInfo serverInfo,
    int selectedTabIndex,
  ) {
    _attendanceSubscription?.cancel();
    _attendanceSubscription = listenAttendanceUseCase().listen(
      (record) {
        final currentState = state;
        if (currentState is! SessionState) return;

        final updatedAttendance = List<AttendanceRecord>.from(
          currentState.session.attendanceList,
        )..add(record);

        final updatedSession = currentState.session.copyWith(
          attendanceList: updatedAttendance,
          connectedClients: updatedAttendance.length,
        );

        emit(
          currentState.copyWith(session: updatedSession, latestRecord: record),
        );

        Future.delayed(const Duration(milliseconds: 100), () {
          final state = this.state;
          if (state is SessionState && state.latestRecord != null) {
            emit(state.copyWith(clearLatestRecord: true));
          }
        });
      },
      onError: (error) {
        debugPrint('❌ Attendance stream error: $error');
      },
    );
  }

  Future<void> endSession() async {
    final currentState = state;
    if (currentState is! SessionState) return;

    try {
      emit(currentState.copyWith(operation: SessionOperation.ending));

      _sessionTimer?.cancel();
      _sessionTimer = null;
      _warningTimer?.cancel();
      _warningTimer = null;

      await _attendanceSubscription?.cancel();
      _attendanceSubscription = null;

      await endSessionUseCase(currentState.session.id, currentState.session);

      final endedSession = currentState.session.copyWith(
        status: SessionStatus.ended,
      );

      emit(
        currentState.copyWith(
          session: endedSession,
          operation: SessionOperation.ended,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      emit(
        SessionManagementIdle(selectedTabIndex: currentState.selectedTabIndex),
      );
    } on ApiErrorModel catch (error) {
      _handleSessionError(error, currentState.selectedTabIndex); 
    } catch (e) {
      _handleSessionError(
        const ApiErrorModel(
          message: 'Failed to end session',
          type: ApiErrorType.unknown,
          statusCode: 500,
        ),
        currentState.selectedTabIndex,
      );
    }
  }

  void _handleSessionError(
    ApiErrorModel error, 
    int selectedTabIndex,
  ) {
    emit(
      SessionError(
        error: error, 
        selectedTabIndex: selectedTabIndex,
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (state is SessionError) {
        emit(SessionManagementIdle(selectedTabIndex: selectedTabIndex));
      }
    });
  }

  @override
  Future<void> close() {
    _attendanceSubscription?.cancel();
    _sessionTimer?.cancel();
    _warningTimer?.cancel();
    return super.close();
  }
}