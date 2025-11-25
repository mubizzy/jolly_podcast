import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiClient {
  static const String baseUrl = 'https://api.jollypodcast.net';
  
  // Common headers
  static Map<String, String> get headers => {
    'accept': 'application/json',
  };

  // POST request with multipart/form-data
  static Future<Map<String, dynamic>> postMultipart(
    String endpoint,
    Map<String, String> fields,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers.addAll(headers);
      
      // Add fields
      request.fields.addAll(fields);

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Handle response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Try to parse error message from response
        try {
          final errorData = json.decode(response.body) as Map<String, dynamic>;
          final errorMessage = errorData['message'] as String? ?? 
                              errorData['error'] as String? ?? 
                              'Request failed with status ${response.statusCode}';
          throw ApiException(errorMessage, response.statusCode);
        } catch (e) {
          throw ApiException(
            'Request failed with status ${response.statusCode}',
            response.statusCode,
          );
        }
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // POST request with JSON body
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        try {
          final errorData = json.decode(response.body) as Map<String, dynamic>;
          final errorMessage = errorData['message'] as String? ?? 
                              errorData['error'] as String? ?? 
                              'Request failed with status ${response.statusCode}';
          throw ApiException(errorMessage, response.statusCode);
        } catch (e) {
          throw ApiException(
            'Request failed with status ${response.statusCode}',
            response.statusCode,
          );
        }
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = {
        ...headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final response = await http.get(uri, headers: requestHeaders);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        try {
          final errorData = json.decode(response.body) as Map<String, dynamic>;
          final errorMessage = errorData['message'] as String? ?? 
                              errorData['error'] as String? ?? 
                              'Request failed with status ${response.statusCode}';
          throw ApiException(errorMessage, response.statusCode);
        } catch (e) {
          throw ApiException(
            'Request failed with status ${response.statusCode}',
            response.statusCode,
          );
        }
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}
