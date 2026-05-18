import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class UserService {
  static const String _base = ApiService.baseUrl;

  static Future<Map<String, dynamic>?> getMe() async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    return data['data'] as Map<String, dynamic>?;
  }

  static Future<void> logout() async {
    await ApiService.saveToken('');
  }
}
