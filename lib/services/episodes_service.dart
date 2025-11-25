import '../models/episode_model.dart';
import '../models/podcast_model.dart';
import 'api_client.dart';
import 'storage_service.dart';

class EpisodesService {
  // Fetch trending episodes
  static Future<List<Episode>> getTrendingEpisodes({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/episodes/trending?page=$page&per_page=$perPage',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;
      final episodesData = innerData['data'] as List<dynamic>;

      // Convert to Episode objects
      return episodesData
          .map((json) => Episode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch trending episodes: ${e.toString()}');
    }
  }

  // Fetch editor's pick episode
  static Future<Episode> getEditorsPick() async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/episodes/editor-pick',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;

      // Convert to Episode object
      return Episode.fromJson(innerData);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch editor\'s pick: ${e.toString()}');
    }
  }

  // Fetch top jolly podcasts
  static Future<List<Podcast>> getTopJollyPodcasts({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/podcasts/top-jolly?page=$page&per_page=$perPage',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;
      final podcastsData = innerData['data'] as List<dynamic>;

      // Convert to Podcast objects
      return podcastsData
          .map((json) => Podcast.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch top jolly podcasts: ${e.toString()}');
    }
  }

  // Fetch latest episodes
  static Future<List<Episode>> getLatestEpisodes({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/episodes/latest?page=$page&per_page=$perPage',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;
      final episodesData = innerData['data'] as List<dynamic>;

      // Convert to Episode objects
      return episodesData
          .map((json) => Episode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch latest episodes: ${e.toString()}');
    }
  }

  // Fetch handpicked podcasts
  static Future<List<Episode>> getHandpickedPodcasts({int amount = 1}) async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/podcasts/handpicked?amount=$amount',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;
      final episodesData = innerData['data'] as List<dynamic>;

      // Convert to Episode objects
      return episodesData
          .map((json) => Episode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        'Failed to fetch handpicked podcasts: ${e.toString()}',
      );
    }
  }

  // Fetch favorite episodes
  static Future<List<Episode>> getFavoriteEpisodes({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/episodes/favourites?page=$page&per_page=$perPage',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;
      final episodesData = innerData['data'] as List<dynamic>;

      // Convert to Episode objects
      return episodesData
          .map((json) => Episode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch favorite episodes: ${e.toString()}');
    }
  }

  // Fetch recently played episodes
  static Future<List<Episode>> getRecentlyPlayedEpisodes({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/episodes/plays?page=$page&per_page=$perPage',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;
      final episodesData = innerData['data'] as List<dynamic>;

      // Convert to Episode objects
      return episodesData
          .map((json) => Episode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch recently played episodes: ${e.toString()}');
    }
  }
}
