import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cartProvider = StateNotifierProvider.family<CartNotifier, List<CartItem>, String>(
  (ref, email) => CartNotifier(email),
);


class CartNotifier extends StateNotifier<List<CartItem>> {
  final String email;

  CartNotifier(this.email) : super([]) {
    loadCart(email);
  }


  static String _key(String email) => 'cart_\$email';

  Future<void> loadCart(String email) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString(_key(email));
  if (data != null) {
    final decoded = jsonDecode(data) as List<dynamic>;
    state = decoded.map((e) => CartItem.fromJson(e)).toList();
  }
}

Future<void> saveCart() async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
  await prefs.setString(_key(email), encoded);
}


 void addItem(CartItem item, String email, ) {
  final index = state.indexWhere(
    (e) => e.name == item.name && e.subcategory == item.subcategory,
  );
  if (index != -1) {
    final updatedItem =
        state[index].copyWith(quantity: state[index].quantity + 1);
    state = [...state]..[index] = updatedItem;
  } else {
    state = [...state, item];
  }
  saveCart();
}

void removeItem(CartItem item) {
  state = state
      .where((e) => e.name != item.name || e.subcategory != item.subcategory)
      .toList();
  saveCart();
}

void increment(CartItem item) => addItem(item, email);

void decrement(CartItem item) {
  final index = state.indexWhere(
    (e) => e.name == item.name && e.subcategory == item.subcategory,
  );
  if (index != -1 && state[index].quantity > 1) {
    final updatedItem =
        state[index].copyWith(quantity: state[index].quantity - 1);
    state = [...state]..[index] = updatedItem;
  } else {
    removeItem(item);
  }
  saveCart();
}

void clearCart() {
  state = [];
  saveCart();
}

}
