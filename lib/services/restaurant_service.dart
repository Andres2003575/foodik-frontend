import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class RestaurantService {
  static final String _base = ApiService.baseUrl;
  static Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('GPS desactivado');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permiso de ubicación denegado permanentemente');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<Map<String, dynamic>> getRegisteredRestaurants({
    double lat = 4.7110,
    double lng = -74.0721,
    double radius = 5.0,
  }) async {
    final token = await ApiService.getToken();
    final response = await http.get(
      Uri.parse('$_base/restaurants?lat=$lat&lng=$lng&radius=$radius&size=20'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }

  static Future<Position> getCurrentPosition() => _getLocation();

  static Future<Map<String, dynamic>> getRestaurants({
    double radius = 5.0,
  }) async {
    final token = await ApiService.getToken();
    final position = await _getLocation();
    print('UBICACION: lat=${position.latitude}, lng=${position.longitude}');

    final response = await http.get(
      Uri.parse(
        '$_base/scraping/nearby?lat=${position.latitude}&lng=${position.longitude}&radiusM=1000',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('SCRAPING RESPONSE: ${response.body}');
    return jsonDecode(response.body);
  }
}
