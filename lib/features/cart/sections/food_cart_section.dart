import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/common/app_button.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/providers/cart_provider.dart';
import 'package:malina_flutter_app/features/cart/widgets/cart_item_card.dart';
import 'package:uuid/uuid.dart';

class FoodCartSection extends ConsumerStatefulWidget {
  const FoodCartSection({super.key});

  @override
  ConsumerState<FoodCartSection> createState() => _FoodCartSectionState();
}

class _FoodCartSectionState extends ConsumerState<FoodCartSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final currentCart = ref.read(cartProvider);
      if (currentCart.isEmpty) {
        ref.read(cartProvider.notifier).addItem(CartItem(
              id: const Uuid().v4(),
              name: 'Том Ям 250 С',
              price: 250,
              quantity: 1,
              category: 'food',
              subcategory: '',
              description: 'Пицца с соусом Тоя Ям',
              imageUrl: 'assets/images/cart_image.png',
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final filteredItems = cartItems
        .where((item) => item.category.toLowerCase() == 'food')
        .toList();
    final subcategories =
        filteredItems.map((e) => e.subcategory).toSet().toList();

    if (filteredItems.isEmpty) {
      return const Center(child: Text('Корзина с едой пуста'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: subcategories.map((subcategory) {
              final items = filteredItems
                  .where((item) => item.subcategory == subcategory)
                  .toList();
              final subtotal = items.fold(
                  0, (sum, item) => sum + item.price * item.quantity);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CartItemCard(item: item),
                      )),
                
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
