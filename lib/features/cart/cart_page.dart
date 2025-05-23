
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'providers/cart_provider.dart';
import 'sections/food_cart_section.dart';
import 'sections/beauty_cart_section.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  int _selectedCategory = 0;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildCategorySwitch(),
          const Divider(thickness: 1),
          Expanded(
            child: _selectedCategory == 0
                ? const FoodCartSection()
                : const BeautyCartSection(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {
            context.push(
                '/add-product/${_selectedCategory == 0 ? 'Еда' : 'Бьюти'}');
          },
          backgroundColor: Color.fromARGB(255, 211, 208, 209),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCategorySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCategoryButton('Еда', 0),
        const SizedBox(width: 16),
        _buildCategoryButton('Бьюти', 1),
      ],
    );
  }

  Widget _buildCategoryButton(String label, int index) {
    final isSelected = _selectedCategory == index;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedCategory = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.buttonColor : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}
