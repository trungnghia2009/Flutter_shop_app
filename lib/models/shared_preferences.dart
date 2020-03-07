import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static Future<void> saveInt(String keyInput, int valueInput) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyInput;
    final value = valueInput;
    prefs.setInt(key, value);
    print('Saved $value');
  }

  static Future readInt(String keyInput) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyInput;
    final value = prefs.getInt(key) ?? 0;
    return value;
  }

  static getInt(String keyInput) {
    return readInt(keyInput);
  }
}
