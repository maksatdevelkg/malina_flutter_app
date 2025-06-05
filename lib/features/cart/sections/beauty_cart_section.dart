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
      ref.read(cartProvider.notifier).loadInitialItemsIfEmpty([
        CartItem(
          id: const Uuid().v4(),
          name: 'HADAT COSMETICS',
          price: 1900,
          quantity: 1,
          category: 'beauty',
          subcategory: 'Hair',
          description:
              'Шампунь восстанавливающий Hydro Intensive Repair 250 мл',
          imageUrl: 'assets/images/cart_image.png',
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final filteredItems = cartItems
        .where((item) => item.category.toLowerCase() == 'beauty')
        .toList();
    final subcategories =
        filteredItems.map((e) => e.subcategory).toSet().toList();

    print('Вся корзина: $cartItems');
    print('Бьюти товары: $filteredItems');

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
                  const SizedBox(height: 8),
                  ...items.map((item) => CartItemCard(item: item)).toList(),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
