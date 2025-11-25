import '../models/podcast_subscription_model.dart';
import 'api_client.dart';
import 'storage_service.dart';

class PodcastsService {
  // Fetch podcast subscriptions
  static Future<Map<String, dynamic>> getSubscriptions({
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
        '/api/podcasts/subscriptions?page=$page&per_page=$perPage',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>;
      final subscriptionsData = innerData['data'] as List<dynamic>;
      final total = innerData['total'] as int;

      // Convert to PodcastSubscription objects
      final subscriptions = subscriptionsData
          .map((json) =>
              PodcastSubscription.fromJson(json as Map<String, dynamic>))
          .toList();

      return {
        'subscriptions': subscriptions,
        'total': total,
        'current_page': innerData['current_page'] as int,
        'last_page': innerData['last_page'] as int,
      };
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
          'Failed to fetch podcast subscriptions: ${e.toString()}');
    }
  }
}
