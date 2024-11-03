import 'package:shared_preferences/shared_preferences.dart';

class SaveLocalStorage {
  static final Future<SharedPreferences> pref = SharedPreferences.getInstance();
}