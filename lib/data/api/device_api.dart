import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/device_model.dart';
import '../models/response/common_response.dart';
import '../models/request/device_request.dart';

class DeviceApi extends BaseApiClient {
  Future<ApiResponse<List<DeviceModel>>> getMyDevices() async {
    return get(
      '/api/device',
      timeout: const Duration(seconds: 60),
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => DeviceModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<MapResponse>> pairDevice({
    required String serialNumber,
    String? nickname,
  }) async {
    return post(
      '/api/device/pair',
      timeout: const Duration(seconds: 60),
      body: PairDeviceRequest(
        serialNumber: serialNumber.trim(),
        nickname: nickname?.trim(),
      ).toJson(),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<DeviceModel>> claimDevice({
    required String code,
    String? nickname,
    String? childName,
  }) async {
    return post(
      '/api/pairing/claim',
      timeout: const Duration(seconds: 60),
      body: ClaimDeviceRequest(
        code: code.trim(),
        nickname: nickname?.trim(),
        childName: childName?.trim(),
      ).toJson(),
      fromJson: (json) => DeviceModel.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> requestOtp({
    required String serialNumber,
  }) async {
    return post(
      '/api/pairing/request_otp',
      timeout: const Duration(seconds: 60),
      body: RequestOtpRequest(serialNumber: serialNumber.trim()).toJson(),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> unpairDevice(String deviceId) async {
    return delete(
      '/api/device/unpair/$deviceId',
      timeout: const Duration(seconds: 60),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> toggleHardwareProtection(String deviceId, bool isEnabled) async {
    return post(
      '/api/device/$deviceId/protection',
      timeout: const Duration(seconds: 60),
      body: ToggleProtectionRequest(isEnabled: isEnabled).toJson(),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> updateProfile(String profileId, Map<String, dynamic> data) async {
    return put(
      '/api/device/profile/$profileId',
      timeout: const Duration(seconds: 60),
      body: data,
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> createProfile(String deviceId, Map<String, dynamic> data) async {
    return post(
      '/api/device/profile/$deviceId',
      timeout: const Duration(seconds: 60),
      body: data,
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  // --- New Real-time Status Logic ---

  /// Checks if the backend server is responding.
  Future<ApiResponse<String>> checkBackendAlive() async {
    return get(
      '/api/debug/alive',
      fromJson: (json) => json.toString(),
    );
  }

  /// Checks the Bridge to see if a specific Bear is currently connected via WebSocket.
  Future<ApiResponse<bool>> isDeviceOnline(String mac) async {
    // Normalize MAC: UPPERCASE, no colons or dashes
    final normMac = mac.replaceAll(':', '').replaceAll('-', '').replaceAll(' ', '').toUpperCase();
    
    // CALL BACKEND PROXY instead of Bridge directly
    return get(
      '/api/device/status/$normMac',
      isBridge: false, // Now calling Backend
      timeout: const Duration(seconds: 10),
      fromJson: (json) {
        if (json is Map && json.containsKey('online')) {
          return json['online'] as bool;
        }
        // Compatibility for different response formats
        if (json is bool) return json;
        return false;
      },
    );
  }
}
