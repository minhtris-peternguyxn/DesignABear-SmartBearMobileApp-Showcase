import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/common_response.dart';
import '../models/request/common_requests.dart';
import '../models/response/safety_response.dart';

class SafetyApi extends BaseApiClient {
  Future<ApiResponse<List<BannedWordModel>>> getBannedWords() async {
    return get(
      '/api/bannedwords',
      timeout: const Duration(seconds: 10),
      fromJson: (json) {
        if (json is List) {
          return json.map((i) => BannedWordModel.fromJson(i)).toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<BannedWordModel>> addBannedWord(String word, {String category = 'personal', bool isGlobal = false}) async {
    return post(
      '/api/bannedwords',
      timeout: const Duration(seconds: 10),
      body: AddBannedWordRequest(word: word, category: category, isGlobal: isGlobal).toJson(),
      fromJson: (json) => BannedWordModel.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> deleteBannedWord(int id) async {
    return delete(
      '/api/bannedwords/$id',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> updateBlockedTopics(String profileId, List<String> topics) async {
    return put(
      '/api/Safety/topics/$profileId',
      timeout: const Duration(seconds: 10),
      rawBody: topics,
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> updateBlockedKeywords(String profileId, List<String> keywords) async {
    return put(
      '/api/Safety/keywords/$profileId',
      timeout: const Duration(seconds: 10),
      rawBody: keywords,
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> updateSafetyResponseMode(String profileId, int mode) async {
    return post(
      '/api/Safety/mode/$profileId?mode=$mode',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }
}
