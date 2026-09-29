import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client client;

  ApiClient({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
      queryParameters: {'apiKey': ApiConstants.apiKey, ...?queryParams},
    );

    try {
      final response = await client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(message: 'Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw NetworkException(message: 'Unexpected error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body['status'] == 'error') {
        throw ServerException(
          message: body['message'] as String? ?? 'Unknown API error',
          statusCode: response.statusCode,
        );
      }
      return body;
    }

    final message =
        body['message'] as String? ??
        'Request failed with status ${response.statusCode}';
    throw ServerException(message: message, statusCode: response.statusCode);
  }

  void dispose() => client.close();
}
