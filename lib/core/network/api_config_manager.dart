import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';

class ApiConfigManager {
  static final ApiConfigManager _instance = ApiConfigManager._internal();
  factory ApiConfigManager() => _instance;
  ApiConfigManager._internal();

  String _baseUrl = AppConfig.defaultBaseUrl;
  String _secretKey = AppConfig.secretKey;
  String _bridgeUrl = AppConfig.defaultBridgeUrl;

  String get baseUrl => _baseUrl;
  String get secretKey => _secretKey;
  String get bridgeUrl => _bridgeUrl;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    _baseUrl = AppConfig.defaultBaseUrl;
    _bridgeUrl = AppConfig.defaultBridgeUrl;

    debugPrint('>>> Network Config Initialized:');
    debugPrint('    Backend: $_baseUrl');
    debugPrint('    Bridge:  $_bridgeUrl');
  }

  void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  void setSecretKey(String key) {
    _secretKey = key;
  }

  void setBridgeUrl(String url) {
    _bridgeUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }
}
