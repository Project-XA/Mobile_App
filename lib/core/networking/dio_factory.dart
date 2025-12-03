import 'package:dio/dio.dart';
import 'package:mobile_app/core/networking/api_const.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


class DioFactory {
  DioFactory._();
  static Dio? _dio;

  static getDio() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConst.baseurl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      _dio?.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
    return _dio;
  }
}
