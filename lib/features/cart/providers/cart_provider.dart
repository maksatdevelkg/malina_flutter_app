import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void loadInitialItems(List<CartItem> items) {
    state = items;
  }

  void addItem(CartItem item) {
    final index = state.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      final updatedItem =
          state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updatedItem;
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void incrementQuantity(String id) {
    final index = state.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedItem =
          state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updatedItem;
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
    }
  }

  void clearCart() {
    state = [];
  }

  int getTotal() {
    return state.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}
