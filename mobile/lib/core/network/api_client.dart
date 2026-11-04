import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
}