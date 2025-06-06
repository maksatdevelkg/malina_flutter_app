import 'dart:convert';

import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> savePassword(String email, String password) async {
    await _prefs.setString('password_$email', password);
  }

  String? getPassword(String email) {
    return _prefs.getString('password_$email');
  }

  Future<void> saveAttempts(String email, int attempts) async {
    await _prefs.setInt('attempts_$email', attempts);
  }

  int getAttempts(String email) {
    return _prefs.getInt('attempts_$email') ?? 0;
  }

  Future<void> deleteUser(String email) async {
    await _prefs.remove('password_$email');
    await _prefs.remove('attempts_$email');
    await _prefs.remove('cart_$email');
    await _prefs.remove('email');
    await _prefs.remove('is_logged_in');
  }

  Future<void> saveEmail(String email) async {
    await _prefs.setString('email', email);

    final existing = _prefs.getStringList('user_emails') ?? [];
    if (!existing.contains(email)) {
      existing.add(email);
      await _prefs.setStringList('user_emails', existing);
    }
  }

  String? getCurrentEmail() {
    return _prefs.getString('email');
  }

  Future<List<String>> getAllUsers() async {
    return _prefs.getStringList('user_emails') ?? [];
  }

  Future<String?> getEmail() async {
    return _prefs.getString('email');
  }

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('is_logged_in', value);
  }

  bool isLoggedIn() {
    return _prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> clearUserData() async {
    final email = _prefs.getString('email');
    if (email != null) {
      await deleteUser(email);
    }
  }

  Future<void> saveCart(String email, List<CartItem> cart) async {
    final encoded = cart.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList('cart_$email', encoded);
  }

  List<CartItem> getCart(String email) {
    final encoded = _prefs.getStringList('cart_$email') ?? [];
    return encoded.map((e) => CartItem.fromJson(jsonDecode(e))).toList();
  }

  Future<void> logout() async {
    await _prefs.setBool('is_logged_in', false);
    await _prefs.remove('email');
  }
}
