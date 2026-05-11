import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config_manager.dart';
import 'api_response.dart';

class BaseApiClient {
  final ApiConfigManager _config = ApiConfigManager();
  final Duration defaultTimeout = const Duration(seconds: 60);

  // Global callback for session expiration (401)
  static void Function()? onUnauthorized;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    return {
      'Content-Type': 'application/json',
      'X-Secret-Key': _config.secretKey,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Duration? timeout,
    bool isBridge = false,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      if (_config.baseUrl.isEmpty) await _config.init();
      
      final baseUrl = isBridge ? _config.bridgeUrl : _config.baseUrl;
      final url = Uri.parse('$baseUrl$path');
      final headers = await _getHeaders();
      
      debugPrint('>>> API CALL: $url (isBridge: $isBridge)');
      
      final response = await http.get(url, headers: headers).timeout(timeout ?? defaultTimeout);
      
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      debugPrint('>>> API ERROR: $path | $e');
      return ApiResponse.failure(ApiError(code: 'NETWORK_ERROR', description: e.toString()));
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    dynamic rawBody,
    Duration? timeout,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      if (_config.baseUrl.isEmpty) await _config.init();

      final url = Uri.parse('${_config.baseUrl}$path');
      final headers = await _getHeaders();
      
      final response = await http
          .post(url, headers: headers, body: rawBody != null ? json.encode(rawBody) : (body != null ? json.encode(body) : null))
          .timeout(timeout ?? defaultTimeout);
          
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.failure(ApiError(code: 'NETWORK_ERROR', description: e.toString()));
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    dynamic rawBody,
    Duration? timeout,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      if (_config.baseUrl.isEmpty) await _config.init();

      final url = Uri.parse('${_config.baseUrl}$path');
      final headers = await _getHeaders();
      
      final response = await http
          .put(url, headers: headers, body: rawBody != null ? json.encode(rawBody) : (body != null ? json.encode(body) : null))
          .timeout(timeout ?? defaultTimeout);
          
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.failure(ApiError(code: 'NETWORK_ERROR', description: e.toString()));
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    dynamic rawBody,
    Duration? timeout,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      if (_config.baseUrl.isEmpty) await _config.init();

      final url = Uri.parse('${_config.baseUrl}$path');
      final headers = await _getHeaders();
      
      final response = await http
          .patch(url, headers: headers, body: rawBody != null ? json.encode(rawBody) : (body != null ? json.encode(body) : null))
          .timeout(timeout ?? defaultTimeout);
          
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.failure(ApiError(code: 'NETWORK_ERROR', description: e.toString()));
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Duration? timeout,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      if (_config.baseUrl.isEmpty) await _config.init();

      final url = Uri.parse('${_config.baseUrl}$path');
      final headers = await _getHeaders();
      
      final response = await http.delete(url, headers: headers).timeout(timeout ?? defaultTimeout);
          
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.failure(ApiError(code: 'NETWORK_ERROR', description: e.toString()));
    }
  }

  Future<ApiResponse<T>> upload<T>(
    String path,
    File file, {
    Duration? timeout,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      if (_config.baseUrl.isEmpty) await _config.init();

      final url = Uri.parse('${_config.baseUrl}$path');
      final headers = await _getHeaders();
      
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send().timeout(timeout ?? const Duration(minutes: 5));
      final response = await http.Response.fromStream(streamedResponse);
      
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.failure(ApiError(code: 'UPLOAD_ERROR', description: e.toString()));
    }
  }

  ApiResponse<T> _processResponse<T>(http.Response response, T Function(dynamic json) fromJson) {
    try {
      final decodedData = response.body.isNotEmpty ? json.decode(response.body) : null;
      
      // Nếu dữ liệu trả về là Map
      if (decodedData is Map<String, dynamic>) {
        debugPrint('>>> API Map received. checking isSuccess...');
        
        // Kiểm tra isSuccess, ưu tiên trường isSuccess từ server, nếu không có thì dựa vào status code
        final bool isSuccess = (decodedData.containsKey('isSuccess') && decodedData['isSuccess'] == true) || 
                              (!decodedData.containsKey('isSuccess') && (response.statusCode >= 200 && response.statusCode < 300 || response.statusCode == 302));
        
        if (isSuccess) {
          final dynamic value = decodedData.containsKey('value') ? decodedData['value'] : decodedData;
          return ApiResponse.success(fromJson(value));
        } else {
          // Thất bại: Trích xuất lỗi, xử lý cả trường hợp 'error' là String hoặc Map
          final dynamic errorData = decodedData['error'] ?? decodedData;
          final error = ApiError.fromJson(errorData);
          
          debugPrint('>>> API Error parsed: [${error.code}] ${error.description}');
          return ApiResponse.failure(error);
        }
      }

      // Xử lý dự phòng cho dữ liệu không phải Map hoặc các chuẩn cũ/thô
      if ((response.statusCode >= 200 && response.statusCode < 300) || response.statusCode == 302) {
        return ApiResponse.success(fromJson(decodedData ?? {}));
      } else {
        if (response.statusCode == 401) {
          debugPrint('>>> API UNAUTHORIZED (401): Triggering global logout...');
          onUnauthorized?.call();
        }
        
        return ApiResponse.failure(ApiError(
          code: 'HTTP_${response.statusCode}', 
          description: 'Server returned ${response.statusCode}'
        ));
      }
    } catch (e) {
      debugPrint('>>> API Parse JSON Error: $e. Body received: ${response.body}');
      return ApiResponse.failure(ApiError(
        code: 'PARSE_ERROR', 
        description: 'Failed to parse response: $e'
      ));
    }
  }
}
