import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/common/app_button.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/core/theme/gap.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/providers/cart_provider.dart';
import 'package:uuid/uuid.dart';

class AddProductPage extends ConsumerStatefulWidget {
  final String initialCategory;
  const AddProductPage({super.key, required this.initialCategory});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _categoryController;
  final _subcategoryController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.initialCategory);
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newItem = CartItem(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        subcategory: _subcategoryController.text.trim(),
        price: int.tryParse(_priceController.text.trim()) ?? 0,
        quantity: 1,
        description: _descriptionController.text.trim(),
        imageUrl: null,
      );

      ref.read(cartProvider.notifier).addItem(newItem);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _subcategoryController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавить',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Сканировать'),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 10),
            child: Image.asset(
              'assets/images/bill_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(_categoryController, 'Категория'),
                  Gap.h24,
                  _buildTextField(_subcategoryController, 'Подкатегория'),
                  Gap.h24,
                  _buildTextField(_nameController, 'Название'),
                  Gap.h24,
                  _buildTextField(_priceController, 'Цена', isNumber: true),
                  Gap.h24,
                  _buildTextField(_descriptionController, 'Описание',
                      maxLines: 8),
                  Gap.h24,
                  AppButton(onPressed: _saveProduct, title: 'Сохранить')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.addProductColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Обязательное поле' : null,
    );
  }
}
