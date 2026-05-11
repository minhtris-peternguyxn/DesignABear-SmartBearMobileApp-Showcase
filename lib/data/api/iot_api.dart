import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/common_response.dart';
import '../models/request/iot_request.dart';

class IotCommandApi extends BaseApiClient {
  Future<ApiResponse<MapResponse>> callDevice({
    String deviceId = 'esp32-default',
    String message = 'Hello from Mobile!',
  }) async {
    return post(
      '/api/call',
      timeout: const Duration(seconds: 10),
      body: CallDeviceRequest(deviceId: deviceId, message: message).toJson(),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> controlLed({
    required String deviceId,
    int r = 255,
    int g = 255,
    int b = 255,
    int brightness = 200,
    String effect = 'static',
    int interval = 500,
  }) async {
    return post(
      '/api/led',
      timeout: const Duration(seconds: 10),
      body: LedControlRequest(
        deviceId: deviceId,
        r: r,
        g: g,
        b: b,
        brightness: brightness,
        effect: effect,
        interval: interval,
      ).toJson(),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  // ==================== Mock APIs ====================
  Future<ApiResponse<MapResponse>> mockPlaySound(String sound) async {
    return post(
      '/api/mock/play_sound',
      body: {'sound': sound},
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> mockLedToggle() async {
    return post(
      '/api/mock/led_toggle',
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> mockGetStatus() async {
    return get(
      '/api/mock/status',
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }
}
