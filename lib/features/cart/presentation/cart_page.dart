import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/core/text_style/app_text_style.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';

import '../sections/food_cart_section.dart';
import '../sections/beauty_cart_section.dart';

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
      backgroundColor: Color(0xffFAFAFB),
      appBar: AppBar(
        title: Text(
          'Корзина',
          style: AppTextStyle.s20w700,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildCategorySwitch(),
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
          backgroundColor: Color(0xffECE6F0),
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
        backgroundColor: isSelected ? AppColors.buttonColor : Color(0xffF8F8F8),
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 12),
      ),
      child: Text(label, style: AppTextStyle.s16w500),
    );
  }
}
