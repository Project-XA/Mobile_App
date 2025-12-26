import 'package:dio/dio.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/core/networking/local_status_codes.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionError:
          return const ApiErrorModel(
            message:
                "No internet connection. Please check your Wi-Fi or mobile data.",
            type: ApiErrorType.connectionError,
            statusCode: LocalStatusCodes.connectionError,
          );

        case DioExceptionType.connectionTimeout:
          return const ApiErrorModel(
            message:
                "The connection took too long. Try checking your internet or try again later.",
            type: ApiErrorType.connectionTimeout,
            statusCode: LocalStatusCodes.connectionTimeout,
          );

        case DioExceptionType.sendTimeout:
          return const ApiErrorModel(
            message: "Request timed out while sending data. Please try again.",
            type: ApiErrorType.sendTimeout,
            statusCode: LocalStatusCodes.sendTimeout,
          );

        case DioExceptionType.receiveTimeout:
          return const ApiErrorModel(
            message: "Server took too long to respond. Please try again later.",
            type: ApiErrorType.receiveTimeout,
            statusCode: LocalStatusCodes.receiveTimeout,
          );

        case DioExceptionType.badCertificate:
          return const ApiErrorModel(
            message:
                "Security issue detected with the server. Connection not secure.",
            type: ApiErrorType.badCertificate,
            statusCode: LocalStatusCodes.badCertificate,
          );

        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode ?? LocalStatusCodes.badResponse;
          final errorMessage = _extractErrorMessage(e.response, statusCode);
          return ApiErrorModel(
            message: errorMessage,
            type: ApiErrorType.badResponse,
            statusCode: e.response?.statusCode ?? LocalStatusCodes.badResponse,
            errorCode: _extractErrorCode(e.response),
          );

        case DioExceptionType.cancel:
          return const ApiErrorModel(
            message: "The request was cancelled. Please try again.",
            type: ApiErrorType.cancel,
            statusCode: LocalStatusCodes.cancel,
          );

        case DioExceptionType.unknown:
          return const ApiErrorModel(
            message:
                "Something went wrong. Please check your connection and try again.",
            type: ApiErrorType.unknown,
            statusCode: LocalStatusCodes.unknown,
          );

        }
    } else {
      return ApiErrorModel(
        message: e.toString().replaceFirst('Exception: ', ''),
        type: ApiErrorType.unknown,
        statusCode: LocalStatusCodes.unknown,
      );
    }
  }

  static String _extractErrorMessage(Response? response,int statusCode) {
    if (response?.data != null) {
      final data = response!.data;
      
      if (data is Map<String, dynamic>) {
        return data['message'] ?? 
               data['error'] ?? 
               data['msg'] ?? 
               'Server returned an error';
      }
    }
    return 'Server returned an unexpected response';
  }

  static String? _extractErrorCode(Response? response) {
    if (response?.data != null && response!.data is Map<String, dynamic>) {
      return response.data['error_code']?.toString();
    }
    return null;
  }
}