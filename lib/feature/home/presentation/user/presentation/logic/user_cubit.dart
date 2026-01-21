import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/domain/entities/user_org.dart';
// import 'package:mobile_app/feature/home/domain/entities/user.dart';
// import 'package:mobile_app/feature/home/domain/entities/user_org.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendency_state.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/nearby_session.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/check_in_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/discover_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/get_attendence_history_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/get_attendence_status_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/get_current_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/start_discovery_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/stop_discover_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/logic/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final StartDiscoveryUseCase startDiscoveryUseCase;
  final StopDiscoveryUseCase stopDiscoveryUseCase;
  final DiscoverSessionsUseCase discoverSessionsUseCase;
  final CheckInUseCase checkInUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;
  final GetAttendanceStatsUseCase getAttendanceStatsUseCase;

  StreamSubscription<NearbySession>? _discoverySubscription;
  Timer? _sessionRefreshTimer;
  Timer? _searchTimeoutTimer;
  Duration searchTimeout = const Duration(seconds: 30);

  bool _sessionFound = false;

  void setSearchTimeout(Duration duration) {
    searchTimeout = duration;
  }

  UserCubit({
    required this.getCurrentUserUseCase,
    required this.startDiscoveryUseCase,
    required this.stopDiscoveryUseCase,
    required this.discoverSessionsUseCase,
    required this.checkInUseCase,
    required this.getAttendanceHistoryUseCase,
    required this.getAttendanceStatsUseCase,
  }) : super(const UserInitial());

  // ===================== User Loading =====================

  Future<void> loadUser() async {
    try {
      emit(const UserLoading());

      // final user = User(
      //   nationalId: '1234569582577',
      //   firstNameAr: 'احمد',
      //   lastNameAr: 'محمد',
      //   address: 'أسيوط - مصر',
      //   birthDate: '1399-05-10',
      //   email: 'ahmed@gmail.com',
      //   firstNameEn: 'Ahmed',
      //   lastNameEn: 'Mohamed',
      //   profileImage: null,
      // );
      final user = await getCurrentUserUseCase.call();
      final stats = await getAttendanceStatsUseCase.call();

      emit(UserIdle(user: user, stats: stats));
    } catch (e) {
      emit(UserError('Failed to load user: $e'));
    }
  }

  // ===================== Session Discovery =====================

  Future<void> startSessionDiscovery() async {
    final currentState = state;
    if (currentState is! UserStateWithUser) return;

    try {
      _sessionFound = false;

      emit(
        SessionDiscoveryActive(
          user: currentState.user,
          isSearching: true,
          stats: _getStatsFromState(currentState),
        ),
      );

      await startDiscoveryUseCase.call();

      _searchTimeoutTimer?.cancel();
      _searchTimeoutTimer = Timer(searchTimeout, () {
        if (!_sessionFound) {
          _handleSearchTimeout();
        }
      });

      _discoverySubscription?.cancel();
      _discoverySubscription = discoverSessionsUseCase.call().listen((session) {
        _sessionFound = true;
        _searchTimeoutTimer?.cancel();
        _handleDiscoveredSession(session);
      }, onError: (error) => _handleDiscoveryError(error));

      _sessionRefreshTimer?.cancel();
      _sessionRefreshTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _refreshSessions(),
      );
    } catch (e) {
      emit(
        UserIdle(
          user: currentState.user,
          stats: _getStatsFromState(currentState),
        ),
      );
    }
  }

  void _handleSearchTimeout() {
    final currentState = state;
    if (currentState is! SessionDiscoveryActive) return;

    final hasSessions = currentState.discoveredSessions.isNotEmpty;

    emit(
      currentState.copyWith(
        isSearching: false,
        clearActiveSession: !hasSessions,
      ),
    );
  }

  void _handleDiscoveredSession(NearbySession session) {
    final currentState = state;
    if (currentState is! SessionDiscoveryActive) return;

    final existingSessions = currentState.discoveredSessions;
    final exists = existingSessions.any(
      (s) => s.sessionId == session.sessionId,
    );

    if (!exists) {
      final updatedSessions = [...existingSessions, session];

      final activeSession = currentState.activeSession ?? session;

      emit(
        currentState.copyWith(
          discoveredSessions: updatedSessions,
          activeSession: activeSession,
          isSearching: false,
        ),
      );
    }
  }

  void _handleDiscoveryError(dynamic error) {
    // Discovery error handled silently
  }

  Future<void> _refreshSessions() async {
    final currentState = state;
    if (currentState is! SessionDiscoveryActive) return;

    final now = DateTime.now();
    final activeSessions = currentState.discoveredSessions
        .where((s) => s.endTime.isAfter(now))
        .toList();

    if (activeSessions.length != currentState.discoveredSessions.length) {
      emit(currentState.copyWith(discoveredSessions: activeSessions));

      if (activeSessions.isEmpty) {
        emit(
          currentState.copyWith(clearActiveSession: true, isSearching: false),
        );
      }
    }
  }

  Future<void> stopSessionDiscovery() async {
    try {
      await _discoverySubscription?.cancel();
      _discoverySubscription = null;

      _sessionRefreshTimer?.cancel();
      _sessionRefreshTimer = null;

      _searchTimeoutTimer?.cancel();
      _searchTimeoutTimer = null;

      _sessionFound = false;

      await stopDiscoveryUseCase.call();

      final currentState = state;
      if (currentState is UserStateWithUser) {
        emit(
          UserIdle(
            user: currentState.user,
            stats: _getStatsFromState(currentState),
          ),
        );
      }
    } catch (e) {
      // Stop discovery error handled silently
    }
  }

  // ===================== Check-In =====================

  Future<void> checkIn(NearbySession session) async {
    final currentState = state;
    if (currentState is! UserStateWithUser) return;

    try {
      emit(
        CheckInState(
          user: currentState.user,
          session: session,
          operation: CheckInOperation.checkingIn,
          stats: _getStatsFromState(currentState),
        ),
      );

      final success = await checkInUseCase.call(
        sessionId: session.sessionId,
        baseUrl: session.baseUrl,
        userId: currentState.user.nationalId,
        userName: currentState.user.fullNameEn,
        location: session.location,
      );

      if (success) {
        final updatedStats = await getAttendanceStatsUseCase.call();

        emit(
          CheckInState(
            user: currentState.user,
            session: session,
            operation: CheckInOperation.success,
            checkInTime: DateTime.now(),
            stats: updatedStats,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        await stopSessionDiscovery();

        emit(UserIdle(user: currentState.user, stats: updatedStats));
      } else {
        emit(
          CheckInState(
            user: currentState.user,
            session: session,
            operation: CheckInOperation.failed,
            errorMessage: 'Check-in failed. Please try again.',
            stats: _getStatsFromState(currentState),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        // Return to previous state
        if (currentState is SessionDiscoveryActive) {
          emit(currentState);
        } else {
          emit(
            UserIdle(
              user: currentState.user,
              stats: _getStatsFromState(currentState),
            ),
          );
        }
      }
    } catch (e) {
      final failedState = CheckInState(
        user: currentState.user,
        session: session,
        operation: CheckInOperation.failed,
        errorMessage: e.toString(),
        stats: _getStatsFromState(currentState),
      );

      emit(failedState);

      await Future.delayed(const Duration(seconds: 2));

      // Return to previous state
      if (currentState is SessionDiscoveryActive) {
        emit(currentState);
      } else {
        emit(
          UserIdle(
            user: currentState.user,
            stats: _getStatsFromState(currentState),
          ),
        );
      }
    }
  }

  Future<void> loadAttendanceHistory() async {
    final currentState = state;
    if (currentState is! UserStateWithUser) return;

    try {
      emit(
        AttendanceHistoryState(
          user: currentState.user,
          history: const [],
          stats:
              _getStatsFromState(currentState) ??
              AttendanceStats(
                totalSessions: 0,
                attendedSessions: 0,
                lateCount: 0,
                attendancePercentage: 0,
              ),
          isLoading: true,
        ),
      );

      final history = await getAttendanceHistoryUseCase.call();
      final stats = await getAttendanceStatsUseCase.call();

      emit(
        AttendanceHistoryState(
          user: currentState.user,
          history: history,
          stats: stats,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(UserError('Failed to load history: $e'));
    }
  }

  Future<void> refreshSessions() async {
    final currentState = state;
    if (currentState is SessionDiscoveryActive) {
      _sessionFound = false;

      emit(
        currentState.copyWith(
          isSearching: true,
          // Keep existing sessions
          clearActiveSession: false,
        ),
      );

      _searchTimeoutTimer?.cancel();
      _searchTimeoutTimer = Timer(searchTimeout, () {
        if (!_sessionFound) {
          _handleSearchTimeout();
        }
      });
    } else if (currentState is UserStateWithUser) {
      await startSessionDiscovery();
    }
  }

  AttendanceStats? _getStatsFromState(UserState state) {
    if (state is UserIdle) return state.stats;
    if (state is SessionDiscoveryActive) return state.stats;
    if (state is CheckInState) return state.stats;
    if (state is AttendanceHistoryState) return state.stats;
    return null;
  }

  @override
  Future<void> close() {
    _discoverySubscription?.cancel();
    _sessionRefreshTimer?.cancel();
    _searchTimeoutTimer?.cancel();
    return super.close();
  }
}
