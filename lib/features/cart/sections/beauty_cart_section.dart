import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/providers/cart_provider.dart';
import 'package:malina_flutter_app/features/cart/widgets/cart_item_card.dart';
import 'package:uuid/uuid.dart';

class BeautyCartSection extends ConsumerStatefulWidget {
  const BeautyCartSection({super.key});

  @override
  ConsumerState<BeautyCartSection> createState() => _BeautyCartSectionState();
}

class _BeautyCartSectionState extends ConsumerState<BeautyCartSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(cartProvider.notifier).loadInitialItems([
        CartItem(
          id: const Uuid().v4(),
          name: 'HADAT COSMETICS 1900',
          price: 1900,
          quantity: 1,
          category: 'Бьюти',
          subcategory: 'Hair',
          description:
              'Шампунь восстанавливающий Hydro Intensive Repair 250 мл',
          imageUrl: 'assets/images/cart_image.png',
        ),
        CartItem(
            id: const Uuid().v4(),
            name: 'HADAT COSMETICS 2000',
            price: 2000,
            quantity: 1,
            category: 'Бьюти',
            subcategory: 'Hair',
            description: 'Увлажняющий кондиционер 150 мл',
            imageUrl: 'assets/images/cart_image.png'),
        CartItem(
            id: const Uuid().v4(),
            name: "L'Oreal Paris Elseve 600",
            price: 600,
            quantity: 1,
            category: 'Бьюти',
            subcategory: 'Preen Beauty',
            description: 'Шампунь для ослабленных волос',
            imageUrl: 'assets/images/cart_image.png'),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final filteredItems =
        cartItems.where((item) => item.category == 'Бьюти').toList();
    final subcategories =
        filteredItems.map((e) => e.subcategory).toSet().toList();

    if (filteredItems.isEmpty) {
      return const Center(child: Text('Корзина с товарами для быта пуста'));
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
              color: AppColors.buttonColor,
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
