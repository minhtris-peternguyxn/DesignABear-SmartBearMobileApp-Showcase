import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/common_response.dart';
import '../models/response/voice_response.dart';

class VoiceApi extends BaseApiClient {
  Future<ApiResponse<List<VoiceModel>>> getVoiceList() async {
    return get(
      '/api/Voice/list',
      timeout: const Duration(seconds: 10),
      fromJson: (json) {
        if (json is List) {
          return json.map((i) => VoiceModel.fromJson(i)).toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<MapResponse>> updateVoicePreference(String provider, String voiceId) async {
    return post(
      '/api/Voice/preference',
      timeout: const Duration(seconds: 10),
      body: {
        'provider': provider,
        'voiceId': voiceId,
      },
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> updateDeviceVoiceConfig({
    required String deviceId,
    required double speed,
    required double volume,
  }) async {
    return post(
      '/api/Voice/config',
      timeout: const Duration(seconds: 10),
      body: {
        'deviceId': deviceId,
        'speed': speed,
        'volume': volume,
      },
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<String>> speak({
    required String text,
    required String voiceId,
    required String provider,
  }) async {
    return post(
      '/api/Voice/speak',
      timeout: const Duration(seconds: 30),
      body: {
        'text': text,
        'voiceId': voiceId,
        'provider': provider,
      },
      fromJson: (json) {
        // Handle if backend returns { value: "url" } or just "url"
        if (json is String) return json;
        if (json is Map && json.containsKey('value')) return json['value'].toString();
        return json.toString();
      },
    );
  }
}
