import '../models/category_model.dart';
import 'api_client.dart';
import 'storage_service.dart';

class CategoriesService {
  // Fetch all categories
  static Future<List<CategoryGroup>> getCategories() async {
    try {
      // Get auth token from storage
      final token = await StorageService.getToken();

      if (token == null) {
        throw ApiException('Authentication token not found. Please log in.');
      }

      // Make API request with authorization header
      final response = await ApiClient.get(
        '/api/categories',
        token: token,
      );

      // Parse response
      final data = response['data'] as Map<String, dynamic>;
      final innerData = data['data'] as List<dynamic>;

      // Convert to CategoryGroup objects
      return innerData
          .map((json) => CategoryGroup.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch categories: ${e.toString()}');
    }
  }
}
