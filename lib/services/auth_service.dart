import '../models/login_response_model.dart';
import 'api_client.dart';

class AuthService {
  // Login with phone number and password
  static Future<LoginResponse> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      // Format phone number - ensure it starts with 234 (Nigeria country code)
      // String formattedPhone = _formatPhoneNumber(phoneNumber);

      // Prepare form fields
      final fields = {
        // 'phone_number': formattedPhone,
        'phone_number': phoneNumber,
        'password': password,
      };

      // Make API request
      final response = await ApiClient.postMultipart('/api/auth/login', fields);

      // Parse response
      return LoginResponse.fromJson(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Login failed: ${e.toString()}');
    }
  }

  // Format phone number to include country code
  // static String _formatPhoneNumber(String phoneNumber) {
  //   // Remove all non-digit characters
  //   String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');

  //   // If it starts with 0, replace with 234
  //   if (cleaned.startsWith('0')) {
  //     cleaned = '234${cleaned.substring(1)}';
  //   }
  //   // If it doesn't start with 234, prepend it
  //   else if (!cleaned.startsWith('234')) {
  //     cleaned = '234$cleaned';
  //   }

  //   return cleaned;
  // }
}
