import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = "favorite_shoe_ids";

  static Future<List<String>> getIds() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_key) ?? [];
  }

  static Future<bool> isFav(String shoeId) async {
    final ids = await getIds();
    return ids.contains(shoeId);
  }

  static Future<void> toggle(String shoeId) async {
    final sp = await SharedPreferences.getInstance();
    final ids = sp.getStringList(_key) ?? [];
    if (ids.contains(shoeId)) {
      ids.remove(shoeId);
    } else {
      ids.add(shoeId);
    }
    await sp.setStringList(_key, ids);
  }

  // Opsional: simpan cache detail sepatu favorit agar lebih cepat tampil
  static Future<void> cacheShoe(Map<String, dynamic> shoe) async {
    final sp = await SharedPreferences.getInstance();
    final key = "shoe_cache_${shoe["id"]}";
    await sp.setString(key, jsonEncode(shoe));
  }

  static Future<Map<String, dynamic>?> getCachedShoe(String id) async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString("shoe_cache_$id");
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }
}
