import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class MenuService {
  static const String _base = ApiService.baseUrl;

  static Future<List<dynamic>> getMenu(String restaurantId) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/restaurants/$restaurantId/menu'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    return data['data'] as List? ?? [];
  }
}
