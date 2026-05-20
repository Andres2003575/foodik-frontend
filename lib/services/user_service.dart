import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class UserService {
  static final String _base = ApiService.baseUrl;
  static Future<Map<String, dynamic>?> searchByEmail(String email) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/users/search?email=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  }

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

  static Future<Map<String, dynamic>?> getUserById(String userId) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  }

  static Future<void> logout() async {
    await ApiService.saveToken('');
  }
}
