import 'api_error_model.dart';

class ApiResult<T> {
  ApiResult._();

  factory ApiResult.success(T data) = ApiSuccess<T>;
  factory ApiResult.error(ApiErrorModel error) = ApiError<T>;

  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(ApiErrorModel error) onError,
  }) {
    if (this is ApiSuccess<T>) {
      return onSuccess((this as ApiSuccess<T>).data);
    } else {
      return onError((this as ApiError<T>).error);
    }
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  ApiSuccess(this.data) : super._();
}

class ApiError<T> extends ApiResult<T> {
  final ApiErrorModel error;
  ApiError(this.error) : super._();
}