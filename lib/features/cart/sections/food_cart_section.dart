import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/widgets/cart_item_card.dart';
import 'package:uuid/uuid.dart';
import 'package:malina_flutter_app/features/auth/providers/auth_provider.dart';
import '../riverpod/riverpod.dart';

class FoodCartSection extends ConsumerStatefulWidget {
  const FoodCartSection({super.key});

  @override
  ConsumerState<FoodCartSection> createState() => _FoodCartSectionState();
}

class _FoodCartSectionState extends ConsumerState<FoodCartSection> {
  String? _email;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final storage = ref.read(localStorageProvider);
      final email = await storage.getEmail();
      setState(() {
        _email = email;
      });

      if (email != null) {
  final currentCart = ref.read(cartProvider(email));
  if (currentCart.isEmpty) {
    ref.read(cartProvider(email).notifier).addItem(
      CartItem(
        id: const Uuid().v4(),
        name: 'Том Ям 250 С',
        price: 250,
        quantity: 1,
        category: 'food',
        subcategory: '',
        description: 'Пицца с соусом Том Ям',
        imageUrl: 'assets/images/cart_image.png',
      ),
      email
    );
  }
}

    }
    
    );
  }


    @override
Widget build(BuildContext context) {
  if (_email == null) {
    return const Center(child: CircularProgressIndicator());
  }

  final cartItems = ref.watch(cartProvider(_email!));

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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CartItemCard(item: item, email: _email!),
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