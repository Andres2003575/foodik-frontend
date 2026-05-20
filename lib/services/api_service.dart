import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final String baseUrl = Platform.isAndroid
      ? 'http://192.168.1.9:8081/api/v1'
      : 'http://192.168.1.9:8081/api/v1';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> saveBillSummary(
    String reservationId,
    Map<String, dynamic> summary,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bill_summary_$reservationId', jsonEncode(summary));
    print(
      'GUARDADO: bill_summary_$reservationId = ${jsonEncode(summary).substring(0, 50)}',
    );
  }

  static Future<Map<String, dynamic>?> getBillSummary(
    String reservationId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('bill_summary_$reservationId');
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  static Future<void> deleteBillSummary(String reservationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bill_summary_$reservationId');
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (data['data'] != null) await saveUserName(data['data']['user']['name']);
    return data;
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (data['data'] != null) await saveUserName(data['data']['user']['name']);
    return data;
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? 'Usuario';
  }
}
