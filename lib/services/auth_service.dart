import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../config/app_config.dart';
import '../core/network/base_api_client.dart';
import '../data/models/request/auth_request.dart';
import '../data/models/response/auth_response.dart';

class AuthService extends BaseApiClient {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: AppConfig.androidClientId, // Android Client ID for identity
    serverClientId: AppConfig.webClientId, // serverClientId for backend auth
    scopes: ['email', 'profile'],
  );

  String? _token;
  Map<String, dynamic>? _user;

  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) return false;

      // Exchange ID Token for JWT using Typed Request/Response Models
      final response = await post<AuthResponse>(
        '/api/auth/google',
        body: LoginRequest(idToken: idToken).toJson(),
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.value != null) {
        final authData = response.value!;
        _token = authData.token;
        
        if (_token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', _token!);
          _user = JwtDecoder.decode(_token!);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('>>> AuthService: LOGIN ERROR: $e');
      if (e.toString().contains('sign_in_failed')) {
        debugPrint('>>> Gợi ý: Kiểm tra SHA-1 fingerprint trên Google Console và Client ID trong .env');
      }
      return false;
    }
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await _googleSignIn.signOut();
    _token = null;
    _user = null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    if (_token != null && !JwtDecoder.isExpired(_token!)) {
      _user = JwtDecoder.decode(_token!);
      return true;
    }
    // Clear stale token
    _token = null;
    _user = null;
    await prefs.remove('jwt_token');
    return false;
  }

  String? get token => _token;
  Map<String, dynamic>? get currentUser => _user;
}
