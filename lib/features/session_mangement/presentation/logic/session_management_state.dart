import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';

sealed class SessionManagementState {
  const SessionManagementState();
}

final class SessionManagementInitial extends SessionManagementState {
  const SessionManagementInitial();
}

final class SessionManagementLoading extends SessionManagementState {
  const SessionManagementLoading();
}

final class SessionManagementError extends SessionManagementState {
  final String message;
  const SessionManagementError(this.message);
}

sealed class SessionManagementStateWithTab extends SessionManagementState {
  final int selectedTabIndex;

  const SessionManagementStateWithTab({
    this.selectedTabIndex = 0,
  });
}

final class SessionManagementIdle extends SessionManagementStateWithTab {
  const SessionManagementIdle({
    super.selectedTabIndex,
  });

  SessionManagementIdle copyWith({
    int? selectedTabIndex,
  }) {
    return SessionManagementIdle(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

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

final class SessionState extends SessionManagementStateWithTab {
  final Session session;
  final SessionOperation operation;
  final ServerInfo? serverInfo;
  final AttendanceRecord? latestRecord;
  final bool showWarning;
  final bool showNetworkError; // ⬅️ إضافة هنا

  const SessionState({
    required this.session,
    required this.operation,
    this.serverInfo,
    this.latestRecord,
    this.showWarning = false,
    this.showNetworkError = false, // ⬅️ إضافة هنا
    super.selectedTabIndex,
  });

  bool get isLoading =>
      operation == SessionOperation.creating ||
      operation == SessionOperation.starting ||
      operation == SessionOperation.ending;

  bool get isActive => operation == SessionOperation.active;

  SessionState copyWith({
    Session? session,
    SessionOperation? operation,
    ServerInfo? serverInfo,
    AttendanceRecord? latestRecord,
    int? selectedTabIndex,
    bool clearLatestRecord = false,
    bool? showWarning,
    bool? showNetworkError, // ⬅️ إضافة هنا
  }) {
    return SessionState(
      session: session ?? this.session,
      operation: operation ?? this.operation,
      serverInfo: serverInfo ?? this.serverInfo,
      latestRecord: clearLatestRecord ? null : (latestRecord ?? this.latestRecord),
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      showWarning: showWarning ?? this.showWarning,
      showNetworkError: showNetworkError ?? this.showNetworkError, // ⬅️ إضافة هنا
    );
  }
}

final class SessionError extends SessionManagementStateWithTab {
  final String message;
  final Session? session;
  final bool isNetworkError; // ⬅️ إضافة للتمييز بين أنواع الأخطاء

  const SessionError({
    required this.message,
    this.session,
    this.isNetworkError = false, 
    super.selectedTabIndex,
  });
}