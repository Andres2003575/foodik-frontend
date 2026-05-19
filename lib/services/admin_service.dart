import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AdminService {
  static const String _base = ApiService.baseUrl;

  static Future<List<dynamic>> getMyRestaurants() async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/restaurants/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }

  static Future<List<dynamic>> getRestaurantReservations(
    String restaurantId,
  ) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/restaurants/$restaurantId/reservations?page=0&size=50'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    return data['data']?['content'] ?? [];
  }

  static Future<void> updateReservationStatus(
    String reservationId,
    String status,
  ) async {
    final token = await ApiService.getToken();
    await http.put(
      Uri.parse('$_base/reservations/$reservationId/status?status=$status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
