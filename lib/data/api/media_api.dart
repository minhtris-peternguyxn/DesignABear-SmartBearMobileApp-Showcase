import 'dart:io';
import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/common_response.dart';
import '../models/response/media_response.dart';

class MediaApi extends BaseApiClient {
  Future<ApiResponse<List<SongModel>>> getSongs() async {
    return get(
      '/api/media/songs',
      timeout: const Duration(seconds: 10),
      fromJson: (json) {
        if (json is List) {
          return json.map((s) => SongModel.fromJson(s)).toList();
        }
        return [];
      },
    );
  }

  /// Uploads a file to GCS (Music, Story, or DemoVoice).
  Future<ApiResponse<MapResponse>> uploadMedia({
    required String filePath,
    required String type,
  }) async {
    return upload(
      '/api/media/upload?type=$type',
      File(filePath),
      timeout: const Duration(minutes: 5),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }
}
