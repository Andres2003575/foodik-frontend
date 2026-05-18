import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ReservationService {
  static const String _base = ApiService.baseUrl;

  static Future<Map<String, dynamic>> getMyReservations() async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/reservations/my?page=0&size=50'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAvailability(
    String restaurantId,
    String date,
    int partySize,
  ) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse(
        '$_base/restaurants/$restaurantId/availability?date=$date&partySize=$partySize',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createReservation(
    String restaurantId,
    String tableSlotId,
    int partySize,
    String notes,
  ) async {
    final token = await ApiService.getToken();
    final response = await http.post(
      Uri.parse('$_base/reservations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'restaurantId': restaurantId,
        'tableSlotId': tableSlotId,
        'partySize': partySize,
        'notes': notes,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> cancelReservation(String id) async {
    final token = await ApiService.getToken();
    final response = await http.put(
      Uri.parse('$_base/reservations/$id/cancel'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }
}
