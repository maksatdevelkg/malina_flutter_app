import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final index = state.indexWhere((e) => e.name == item.name && e.subcategory == item.subcategory);
    if (index != -1) {
      final updatedItem = state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updatedItem;
    } else {
      state = [...state, item];
    }
  }

  void removeItem(CartItem item) {
    state = state.where((e) => e.name != item.name || e.subcategory != item.subcategory).toList();
  }

  void increment(CartItem item) {
    addItem(item);
  }

  void decrement(CartItem item) {
    final index = state.indexWhere((e) => e.name == item.name && e.subcategory == item.subcategory);
    if (index != -1 && state[index].quantity > 1) {
      final updatedItem = state[index].copyWith(quantity: state[index].quantity - 1);
      state = [...state]..[index] = updatedItem;
    } else {
      removeItem(item);
    }
  }

  double getTotal() {
    return state.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}
