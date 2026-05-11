import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/common_response.dart';
import '../models/request/common_requests.dart';
import '../models/response/alarm_response.dart';

class AlarmApi extends BaseApiClient {
  Future<ApiResponse<List<AlarmModel>>> getAlarms() async {
    return get(
      '/api/SmartAlarm',
      timeout: const Duration(seconds: 10),
      fromJson: (json) {
        if (json is List) {
          return json.map((i) => AlarmModel.fromJson(i)).toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<MapResponse>> createAlarm(AlarmRequest data) async {
    return post(
      '/api/SmartAlarm',
      timeout: const Duration(seconds: 10),
      body: data.toJson(),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> updateAlarm(String alarmId, AlarmRequest data) async {
    return put(
      '/api/SmartAlarm/$alarmId',
      timeout: const Duration(seconds: 10),
      body: data.toJson(),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> toggleAlarm(String alarmId) async {
    return patch(
      '/api/SmartAlarm/$alarmId/toggle',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> deleteAlarm(String alarmId) async {
    return delete(
      '/api/SmartAlarm/$alarmId',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }
}
