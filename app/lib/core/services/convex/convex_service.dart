import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';

/// Thin HTTP wrapper around the Convex Cloud HTTP API.
///
/// Every mutation is posted to:
///   POST  <deploymentUrl>/api/mutation
///   Body  { "path": "<module>:<function>", "args": {...}, "format": "json" }
class ConvexService {
  ConvexService({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;
  final String _baseUrl = AppConstants.convexDeploymentUrl;

  Future<void> saveCall(Map<String, dynamic> args) async {
    await _dio.post(
      '$_baseUrl/api/mutation',
      data: <String, dynamic>{
        'path': AppConstants.convexSaveCallPath,
        'args': args,
        'format': 'json',
      },
    );
  }

  static Dio _buildDio() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}
