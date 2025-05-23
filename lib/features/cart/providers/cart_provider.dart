// cart_provider.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  static const _storageKey = 'cart_items';

  CartNotifier() : super([]) {
    _loadCart();
  }

  void loadInitialItemsIfEmpty(List<CartItem> items) {
  if (state.isEmpty) {
    state = [...items];
    _saveCart();
  }
}

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      final decoded = jsonDecode(data) as List<dynamic>;
      state = decoded.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void addItem(CartItem item) {
    final index = state.indexWhere((e) =>
      e.name == item.name &&
      e.category == item.category &&
      e.subcategory == item.subcategory);

    if (index != -1) {
      final updatedItem =
          state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updatedItem;
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
      final updatedItem =
          state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updatedItem;
      _saveCart();
    }
  }

  void decrementQuantity(String id) {
    final index = state.indexWhere((e) => e.id == id);
    if (index != -1) {
      if (state[index].quantity > 1) {
        final updatedItem =
            state[index].copyWith(quantity: state[index].quantity - 1);
        state = [...state]..[index] = updatedItem;
      } else {
        removeItem(id);
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
