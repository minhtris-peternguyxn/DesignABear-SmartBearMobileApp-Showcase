import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/common_response.dart';
import '../models/response/history_response.dart';

class HistoryApi extends BaseApiClient {
  Future<ApiResponse<List<ChatSessionModel>>> getChatSessions(String profileId) async {
    return get(
      '/api/history/sessions/$profileId',
      timeout: const Duration(seconds: 10),
      fromJson: (json) {
        if (json is List) {
          return json.map((i) => ChatSessionModel.fromJson(i)).toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<SessionDetailModel>> getSessionDetails(String sessionId) async {
    return get(
      '/api/history/session/$sessionId',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => SessionDetailModel.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> deleteSession(String sessionId) async {
    return delete(
      '/api/history/session/$sessionId',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }
}
