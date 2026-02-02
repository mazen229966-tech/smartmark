import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_keys.dart';

class PrefsHelper {
  static Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  static Future<bool> getHasOnboarded() async {
    final p = await _prefs;
    return p.getBool(AppKeys.hasOnboarded) ?? false;
  }

  static Future<void> setHasOnboarded(bool value) async {
    final p = await _prefs;
    await p.setBool(AppKeys.hasOnboarded, value);
  }

  static Future<String?> getUsername() async {
    final p = await _prefs;
    return p.getString(AppKeys.username);
  }

  static Future<void> setUsername(String name) async {
    final p = await _prefs;
    await p.setString(AppKeys.username, name);
  }

  static Future<void> clearAll() async {
    final p = await _prefs;
    await p.clear();
  }


  static Future<String?> getBrandImagePath() async {
  final p = await _prefs;
  return p.getString(AppKeys.brandImagePath);
}

static Future<void> setBrandImagePath(String? path) async {
  final p = await _prefs;
  if (path == null || path.trim().isEmpty) {
    await p.remove(AppKeys.brandImagePath);
  } else {
    await p.setString(AppKeys.brandImagePath, path);
  }
}


static Future<List<String>> getFavoriteTips() async {
  final p = await _prefs;
  return p.getStringList(AppKeys.favoriteTips) ?? <String>[];
}

static Future<void> setFavoriteTips(List<String> ids) async {
  final p = await _prefs;
  await p.setStringList(AppKeys.favoriteTips, ids);
}

}
