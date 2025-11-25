import '../models/playlist_model.dart';
import 'api_client.dart';
import 'storage_service.dart';

class PlaylistsService {
  // Fetch playlists
  static Future<PaginatedPlaylistResponse> getPlaylists({
    String? name,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Build query parameters
      final queryParams = <String>[];
      if (name != null && name.isNotEmpty) {
        queryParams.add('name=$name');
      }
      queryParams.add('page=$page');
      queryParams.add('per_page=$perPage');

      final queryString = queryParams.join('&');

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/playlists?$queryString',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;

      // Convert to PaginatedPlaylistResponse
      return PaginatedPlaylistResponse.fromJson(innerData);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch playlists: ${e.toString()}');
    }
  }
}
