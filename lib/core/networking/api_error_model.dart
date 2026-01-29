import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_model.freezed.dart';

@freezed
class ApiErrorModel with _$ApiErrorModel {
  const factory ApiErrorModel({
    required String message,
    required ApiErrorType type,
    required int statusCode,
    String? errorCode,
  }) = _ApiErrorModel;
}

enum ApiErrorType {
  connectionError,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badCertificate,
  badResponse,
  cancel,
  unknown,
  defaultError,
}

extension ApiErrorTypeExtension on ApiErrorType {
  String get iconName {
    switch (this) {
      case ApiErrorType.connectionError:
        return 'wifi_off';
      case ApiErrorType.connectionTimeout:
        return 'timer_off';
      case ApiErrorType.sendTimeout:
        return 'send';
      case ApiErrorType.receiveTimeout:
        return 'downloading';
      case ApiErrorType.badCertificate:
        return 'security';
      case ApiErrorType.badResponse:
        return 'warning';
      case ApiErrorType.cancel:
        return 'cancel';
      case ApiErrorType.unknown:
        return 'error_outline';
      case ApiErrorType.defaultError:
        return 'error';
    }
  }

  bool get isNetworkError {
    return this == ApiErrorType.connectionError ||
        this == ApiErrorType.connectionTimeout ||
        this == ApiErrorType.sendTimeout ||
        this == ApiErrorType.receiveTimeout;
  }
}

extension ApiErrorModelX on ApiErrorModel {
  bool get isNetworkError => type.isNetworkError;
}
