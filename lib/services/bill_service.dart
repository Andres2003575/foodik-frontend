import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class BillService {
  static const String _base = ApiService.baseUrl;

  static Future<Map<String, dynamic>> createBill(
    String reservationId,
    String splitMode,
    List<Map<String, dynamic>> items,
  ) async {
    final token = await ApiService.getToken();
    final response = await http.post(
      Uri.parse('$_base/bills'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'reservationId': reservationId,
        'splitMode': splitMode,
        'items': items,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> splitBill(
    String billId,
    String splitMode,
    List<String> participantIds,
  ) async {
    final token = await ApiService.getToken();
    final response = await http.post(
      Uri.parse('$_base/bills/$billId/split'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'splitMode': splitMode,
        'participants': participantIds,
        'chain': null,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>?> getBillByReservation(
    String reservationId,
  ) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/bills/reservation/$reservationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  }

  static Future<Map<String, dynamic>> getBillSummary(String billId) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/bills/$billId/summary'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }
}
