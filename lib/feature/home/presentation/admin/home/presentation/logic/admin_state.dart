import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';

sealed class AdminState {
  const AdminState();
}

// Initial & Loading States
final class AdminInitial extends AdminState {
  const AdminInitial();
}

final class AdminLoading extends AdminState {
  const AdminLoading();
}

final class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);
}

// Base state with user loaded - all states after loading should extend this
sealed class AdminStateWithUser extends AdminState {
  final User user;
  final int selectedTabIndex;
  
  const AdminStateWithUser({
    required this.user,
    this.selectedTabIndex = 0,
  });
}

// Idle state - no active session
final class AdminIdle extends AdminStateWithUser {
  const AdminIdle({
    required super.user,
    super.selectedTabIndex,
  });

  AdminIdle copyWith({
    User? user,
    int? selectedTabIndex,
  }) {
    return AdminIdle(
      user: user ?? this.user,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

// Session operation states
enum SessionOperation { creating, starting, active, ending, ended }

extension SessionOperationX on SessionOperation {
  String get message {
    switch (this) {
      case SessionOperation.creating:
        return 'Creating session...';
      case SessionOperation.starting:
        return 'Starting server...';
      case SessionOperation.ending:
        return 'Ending session...';
      case SessionOperation.ended:
        return 'Session ended successfully';
      case SessionOperation.active:
        return 'Session is active';
    }
  }
}

final class SessionState extends AdminStateWithUser {
  final Session session;
  final SessionOperation operation;
  final ServerInfo? serverInfo;
  final AttendanceRecord? latestRecord;

  const SessionState({
    required super.user,
    required this.session,
    required this.operation,
    this.serverInfo,
    this.latestRecord,
    super.selectedTabIndex,
  });

  bool get isLoading => 
      operation == SessionOperation.creating || 
      operation == SessionOperation.starting ||
      operation == SessionOperation.ending;

  bool get isActive => operation == SessionOperation.active;

  SessionState copyWith({
    User? user,
    Session? session,
    SessionOperation? operation,
    ServerInfo? serverInfo,
    AttendanceRecord? latestRecord,
    int? selectedTabIndex,
    bool clearLatestRecord = false,
  }) {
    return SessionState(
      user: user ?? this.user,
      session: session ?? this.session,
      operation: operation ?? this.operation,
      serverInfo: serverInfo ?? this.serverInfo,
      latestRecord: clearLatestRecord ? null : (latestRecord ?? this.latestRecord),
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

final class SessionError extends AdminStateWithUser {
  final String message;
  final Session? session;

  const SessionError({
    required super.user,
    required this.message,
    this.session,
    super.selectedTabIndex,
  });
}