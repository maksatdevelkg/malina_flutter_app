import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: const Text('Добавить'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Сканировать'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_categoryController, 'Категория'),
              const SizedBox(height: 12),
              _buildTextField(_subcategoryController, 'Подкатегория'),
              const SizedBox(height: 12),
              _buildTextField(_nameController, 'Название'),
              const SizedBox(height: 12),
              _buildTextField(_priceController, 'Цена', isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(_descriptionController, 'Описание', maxLines: 4),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF93E66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      const Text('Сохранить', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
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
        fillColor: const Color(0xFFFFF1F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Обязательное поле' : null,
    );
  }
}
