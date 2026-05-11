import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get defaultBaseUrl => dotenv.env['BASE_URL'] ?? 'https://ai.designabear.shop';
  static String get backupBaseUrl => dotenv.env['BACKUP_BASE_URL'] ?? '';
  static String get defaultBridgeUrl => dotenv.env['BRIDGE_URL'] ?? 'https://stream.designabear.shop';
  static String get backupBridgeUrl => dotenv.env['BACKUP_BRIDGE_URL'] ?? '';
  static String get secretKey => dotenv.env['SECRET_KEY'] ?? 'dab-secret-2026';
  
  static String get baseUrl => defaultBaseUrl;
  static String get bridgeUrl => defaultBridgeUrl;
  
  // Google OAuth Client IDs
  static String get androidClientId => dotenv.env['ANDROID_CLIENT_ID'] ?? '';
  static String get webClientId => dotenv.env['WEB_CLIENT_ID'] ?? ''; 
}
