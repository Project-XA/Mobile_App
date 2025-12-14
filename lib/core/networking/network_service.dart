import 'package:dio/dio.dart';
import 'package:mobile_app/core/networking/dio_factory.dart';

abstract class NetworkService {
  Future<Response> get(String url);
  Future<Response> post(String url, dynamic body);
}

class NetworkServiceImp extends NetworkService {
  final dio = DioFactory.getDio();
  @override
  Future<Response> get(String url) async {
    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  @override
  Future<Response> post(String url, dynamic body) async {
    try {
      final response = await dio.post(url, data: body);
      return response;
    } catch (e) {
      rethrow; 
    }
  }
}
