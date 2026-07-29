import 'package:shared_preferences/shared_preferences.dart';

class OrientationService {
  static const String _orientationShownKey =
      'combinasom_algebrico_orientation_shown';

  static const String _combinatoricsTutorialShownKey =
      'combinasom_algebrico_tutorial_shown';

  Future<bool> hasShownOrientation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_orientationShownKey) ?? false;
  }

  Future<void> markOrientationAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_orientationShownKey, true);
  }

  Future<bool> hasShownCombinatoricsTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_combinatoricsTutorialShownKey) ?? false;
  }

  Future<void> markCombinatoricsTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_combinatoricsTutorialShownKey, true);
  }

  Future<void> resetCombinatoricsTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_combinatoricsTutorialShownKey);
  }
}
