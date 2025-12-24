import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/domain/entities/user_org.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/get_current_user_use_case.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CreateSessionUseCase createSessionUseCase;
  final StartSessionServerUseCase startSessionServerUseCase;
  final EndSessionUseCase endSessionUseCase;
  final ListenAttendanceUseCase listenAttendanceUseCase;

  StreamSubscription<AttendanceRecord>? _attendanceSubscription;

  AdminCubit({
    required this.getCurrentUserUseCase,
    required this.createSessionUseCase,
    required this.startSessionServerUseCase,
    required this.endSessionUseCase,
    required this.listenAttendanceUseCase,
  }) : super(const AdminInitial());

  // ===================== User Loading =====================
  
  Future<void> loadUser() async {
    try {
      emit(const AdminLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      // TODO: Uncomment when ready
      // final user = await getCurrentUserUseCase.call();
      
      final user = User(
        nationalId: '123456667',
        firstNameAr: 'عادل',
        lastNameAr: 'محمد',
        address: 'أسيوط - مصر',
        birthDate: '1999-05-10',
        email: 'adel@gmail.com',
        firstNameEn: 'Adel',
        lastNameEn: 'Mohamed',
        organizations: [UserOrg(orgId: '1234', role: 'admin')],
        profileImage: null,
      );

      emit(AdminIdle(user: user));
    } catch (e) {
      emit(AdminError('Failed to load user: $e'));
    }
  }

  // ===================== Tab Navigation =====================
  
  void changeTab(int index) {
    final currentState = state;
    
    if (currentState is AdminIdle) {
      emit(currentState.copyWith(selectedTabIndex: index));
    } else if (currentState is SessionState) {
      emit(currentState.copyWith(selectedTabIndex: index));
    }
  }

  // ===================== Session Management =====================
  
  Future<void> createAndStartSession({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
  }) async {
    final currentState = state;
    if (currentState is! AdminStateWithUser) return;

    try {
      // Step 1: Create session
      await _createSession(
        user: currentState.user,
        name: name,
        location: location,
        connectionMethod: connectionMethod,
        startTime: startTime,
        durationMinutes: durationMinutes,
        selectedTabIndex: currentState.selectedTabIndex,
      );

      // Step 2: Start server and activate session
      await _startServer(currentState.user, currentState.selectedTabIndex);

    } catch (e) {
      _handleSessionError(
        currentState.user,
        'Failed to start session: $e',
        currentState.selectedTabIndex,
      );
    }
  }

  Future<void> _createSession({
    required User user,
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int selectedTabIndex,
  }) async {
    // Show creating state
    final now = DateTime.now();
    final sessionStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    final placeholderSession = Session(
      id: '',
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: sessionStartTime,
      durationMinutes: durationMinutes,
      status: SessionStatus.inactive,
      connectedClients: 0,
      attendanceList: [],
    );

    emit(SessionState(
      user: user,
      session: placeholderSession,
      operation: SessionOperation.creating,
      selectedTabIndex: selectedTabIndex,
    ));

    // Create session via use case
    final session = await createSessionUseCase(
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: sessionStartTime,
      durationMinutes: durationMinutes,
    );

    await Future.delayed(const Duration(milliseconds: 500));

    // Update state with created session
    emit(SessionState(
      user: user,
      session: session,
      operation: SessionOperation.starting,
      selectedTabIndex: selectedTabIndex,
    ));
  }

  Future<void> _startServer(User user, int selectedTabIndex) async {
    final currentState = state;
    if (currentState is! SessionState) return;

    // Start server
    final serverInfo = await startSessionServerUseCase(currentState.session.id);

    // Start listening to attendance
    _listenToAttendance(user, currentState.session, serverInfo, selectedTabIndex);

    // Activate session
    final activeSession = currentState.session.copyWith(
      status: SessionStatus.active,
    );

    emit(SessionState(
      user: user,
      session: activeSession,
      operation: SessionOperation.active,
      serverInfo: serverInfo,
      selectedTabIndex: selectedTabIndex,
    ));
  }

  // ===================== Attendance Listening =====================
  
  void _listenToAttendance(
    User user,
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

        // Emit with latest record (for animations/notifications)
        emit(currentState.copyWith(
          session: updatedSession,
          latestRecord: record,
        ));

        // Clear latest record after a short delay
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

  // ===================== End Session =====================
  
  Future<void> endSession() async {
    final currentState = state;
    if (currentState is! SessionState) return;

    try {
      // Show ending state
      emit(currentState.copyWith(operation: SessionOperation.ending));

      // Cancel attendance subscription
      await _attendanceSubscription?.cancel();
      _attendanceSubscription = null;

      // End session via use case
      await endSessionUseCase(currentState.session.id);

      // Show ended state
      final endedSession = currentState.session.copyWith(
        status: SessionStatus.ended,
      );

      emit(currentState.copyWith(
        session: endedSession,
        operation: SessionOperation.ended,
      ));

      // Wait for UI feedback
      await Future.delayed(const Duration(seconds: 2));

      // Return to idle state
      emit(AdminIdle(
        user: currentState.user,
        selectedTabIndex: currentState.selectedTabIndex,
      ));
    } catch (e) {
      _handleSessionError(
        currentState.user,
        'Failed to end session: $e',
        currentState.selectedTabIndex,
      );
    }
  }

  // ===================== Error Handling =====================
  
  void _handleSessionError(User user, String message, int selectedTabIndex) {
    emit(SessionError(
      user: user,
      message: message,
      selectedTabIndex: selectedTabIndex,
    ));

    Future.delayed(const Duration(seconds: 2), () {
      if (state is SessionError) {
        emit(AdminIdle(
          user: user,
          selectedTabIndex: selectedTabIndex,
        ));
      }
    });
  }

  // ===================== Cleanup =====================
  
  @override
  Future<void> close() {
    _attendanceSubscription?.cancel();
    return super.close();
  }
}