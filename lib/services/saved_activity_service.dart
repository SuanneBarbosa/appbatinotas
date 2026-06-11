import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_activity_model.dart';

class SavedActivityService {
  static const String _key = 'saved_combinasom_activities';

  static Future<List<SavedActivityModel>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list.map((item) {
      final json = jsonDecode(item) as Map<String, dynamic>;
      return SavedActivityModel.fromJson(json);
    }).toList();
  }

  static Future<void> saveActivity(SavedActivityModel activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getActivities();

    activities.insert(0, activity);

    final encoded = activities.map((item) {
      return jsonEncode(item.toJson());
    }).toList();

    await prefs.setStringList(_key, encoded);
  }

  static Future<void> deleteActivity(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getActivities();

    activities.removeWhere((item) => item.id == id);

    final encoded = activities.map((item) {
      return jsonEncode(item.toJson());
    }).toList();

    await prefs.setStringList(_key, encoded);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
