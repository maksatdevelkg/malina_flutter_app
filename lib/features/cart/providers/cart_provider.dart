import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CartNotifier extends StateNotifier<List<CartItem>> {
  final String _email;

  CartNotifier(this._email) : super([]) {
    _loadCart();
  }

  void _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('cart_$_email');
    if (json != null) {
      final decoded = jsonDecode(json) as List;
      state = decoded.map((e) => CartItem.fromJson(e)).toList();
    }
  }


  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString('cart_$_email', encoded);
  }

  void addItem(CartItem item) {
    final index = state.indexWhere((e) =>
        e.name == item.name &&
        e.category == item.category &&
        e.subcategory == item.subcategory);

    if (index != -1) {
      final updated = state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updated;
    } else {
      state = [...state, item];
    }
    _saveCart();
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
    _saveCart();
  }

  void incrementQuantity(String id) {
    final index = state.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updated = state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updated;
      _saveCart();
    }
  }

  void decrementQuantity(String id) {
    final index = state.indexWhere((e) => e.id == id);
    if (index != -1) {
      if (state[index].quantity > 1) {
        final updated = state[index].copyWith(quantity: state[index].quantity - 1);
        state = [...state]..[index] = updated;
      } else {
        removeItem(id);
        return;
      }
      _saveCart();
    }
  }

  void clearCart() {
    state = [];
    _saveCart();
  }

  int getTotal() {
    return state.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}
