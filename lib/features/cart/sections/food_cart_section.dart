import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ref.read(cartProvider.notifier).loadInitialItems([
        CartItem(
          id: const Uuid().v4(),
          name: 'Том Ям 250 С',
          imageUrl: 'assets/images/food_image.png',
          price: 250,
          quantity: 1,
          category: 'Еда',
          subcategory: 'Bellagio Coffee',
          description: 'Пицца с соусом том ям 230 гр',
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final filteredItems =
        cartItems.where((item) => item.category == 'Еда').toList();
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subcategory,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...items.map((item) => CartItemCard(item: item)).toList(),
                ],
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFF93E66),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Всего',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${filteredItems.fold(0, (sum, item) => sum + item.price * item.quantity)} C',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
