// lib/infrastructure/local_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  String? get email => _prefs.getString('email');

  Future<void> saveEmail(String email) async {
    await _prefs.setString('email', email);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
