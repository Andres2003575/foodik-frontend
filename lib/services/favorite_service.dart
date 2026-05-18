import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorites';

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> addFavorite(Map<String, dynamic> restaurant) async {
    final favorites = await getFavorites();
    final exists = favorites.any((r) => r['name'] == restaurant['name']);
    if (!exists) {
      favorites.add(restaurant);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(favorites));
    }
  }

  static Future<void> removeFavorite(String name) async {
    final favorites = await getFavorites();
    favorites.removeWhere((r) => r['name'] == name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(favorites));
  }

  static Future<bool> isFavorite(String name) async {
    final favorites = await getFavorites();
    return favorites.any((r) => r['name'] == name);
  }
}
