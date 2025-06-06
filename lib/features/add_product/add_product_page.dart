import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/common/app_button.dart';
import 'package:malina_flutter_app/core/text_style/app_text_style.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/core/theme/gap.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/riverpod/riverpod.dart';
import 'package:malina_flutter_app/features/qr_scanner/presentation/qr_scanner_page.dart';
import 'package:uuid/uuid.dart';
import 'package:malina_flutter_app/features/auth/providers/auth_provider.dart';


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

  final Map<String, String> categoryOptions = {
    'Еда': 'food',
    'Бьюти': 'beauty',
  };

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.initialCategory);
  }

 Future<void> _saveProduct() async {
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

    final storage = ref.read(localStorageProvider);
    final email = await storage.getEmail();

    if (email != null) {
      ref.read(cartProvider(email).notifier).addItem(newItem, email);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь не найден')),
      );
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new), 
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Добавить', style: AppTextStyle.s20w700),
        actions: [
          TextButton(
            onPressed: () {},
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QrScannerPage()));
              },
              child: const Text(
                'Сканировать',
                style: TextStyle(color: Color(0xff1D1D1D), fontSize: 14),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
                width: 380, height: 750, child: PinkBackgroundPainter()),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: categoryOptions.entries
                        .firstWhere((e) => e.value == _categoryController.text,
                            orElse: () => const MapEntry('Еда', 'food'))
                        .key,
                    decoration: InputDecoration(
                      labelText: 'Категория',
                      filled: true,
                      fillColor: AppColors.addProductColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    items: categoryOptions.keys.map((label) {
                      return DropdownMenuItem<String>(
                        value: label,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (selectedLabel) {
                      if (selectedLabel != null) {
                        setState(() {
                          _categoryController.text =
                              categoryOptions[selectedLabel]!;
                        });
                      }
                    },
                  ),
                  Gap.h24,
                  _buildTextField(_subcategoryController, 'Подкатегория'),
                  Gap.h24,
                  _buildTextField(_nameController, 'Название'),
                  Gap.h24,
                  _buildTextField(_priceController, 'Цена', isNumber: true),
                  Gap.h24,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Описание',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff49454F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(_descriptionController, '', maxLines: 8),
                    ],
                  ),
                  Gap.h24,
                  AppButton(onPressed: _saveProduct, title: 'Сохранить'),
                ],
              ),
            ),
          )
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
        hintStyle: TextStyle(color: Color(0xff49454F)),
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

class PinkBackgroundPainter extends StatelessWidget {
  const PinkBackgroundPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ReceiptPainter(),
      child: Container(
        width: double.infinity,
        height: 400,
        padding: const EdgeInsets.all(20),
      ),
    );
  }
}

class ReceiptPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffFFECEC)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 20);
    path.quadraticBezierTo(0, 0, 20, 0);
    path.lineTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);

    path.lineTo(size.width, size.height - 80);

    const waveHeight = 50.0;
    const waveWidth = 80.0;

    for (double i = size.width; i > 0; i -= waveWidth) {
      path.quadraticBezierTo(
        i - waveWidth / 2,
        size.height + waveHeight,
        i - waveWidth,
        size.height - 50,
      );
    }

    path.lineTo(0, size.height - 40);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
