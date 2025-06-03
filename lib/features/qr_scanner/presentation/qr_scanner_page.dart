import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/providers/cart_provider.dart';

class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({super.key});

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool isProcessing = false;
  CartItem? scannedItem;

  Future<void> _handleQrCode(String code) async {
    if (code.isEmpty || isProcessing) return;
    isProcessing = true;
    _controller.stop();

    final parts = code.split('/');
    if (parts.length < 5) {
      await showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Некорректный QR-код',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Получено: $code', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Сканировать снова'),
              ),
            ],
          ),
        ),
      );
      _controller.start();
      setState(() => isProcessing = false);
      return;
    }

    final category = parts[0].trim();
    final subcategory = parts[1].trim();
    final name = parts[2].trim();
    final price = int.tryParse(parts[3].trim()) ?? 0;
    final description = parts[4].trim();

    final item = CartItem(
      name: name,
      category: category,
      subcategory: subcategory,
      price: price,
      quantity: 1,
      description: description,
      imageUrl: _getImageBySubcategoryAndName(subcategory, name),
    );

    setState(() => scannedItem = item);
  }

  String _getImageBySubcategoryAndName(String subcategory, String name) {
    final sub = subcategory.toLowerCase();
    final lowerName = name.toLowerCase();

    if (lowerName.contains('tea') && sub.contains('hot')) {
      return 'assets/images/tea_image.png';
    }

    if (lowerName.contains('tea') && sub.contains('cold')) {
      return 'assets/images/cold_tea_image.png';
    }

    if (lowerName.contains('pizza')) return 'assets/images/pizza_image.png';

    if (sub.contains('hot')) return 'assets/images/hot_food.png';
    if (sub.contains('cold')) return 'assets/images/cold_food.png';
    if (sub.contains('shampoo')) return 'assets/images/shampoo_image.png';

    return 'assets/images/default_image.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;
              if (code != null) {
                _handleQrCode(code);
              }
            },
          ),
          ScannerOverlay(),
          const Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Поместите QR-код в рамку',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          if (scannedItem != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            scannedItem?.imageUrl ??
                                'assets/images/default_image.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(scannedItem?.name ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(scannedItem?.description ?? '',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text('${scannedItem?.price ?? 0} C',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF93E66),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (scannedItem != null) {
                            ref
                                .read(cartProvider.notifier)
                                .addItem(scannedItem!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '«${scannedItem!.name}» добавлен в корзину')),
                            );
                          }
                          setState(() {
                            scannedItem = null;
                            isProcessing = false;
                          });
                          _controller.start();
                        },
                        child: const Text('Добавить',
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends StatelessWidget {
  final double cutOutSize;
  final double borderLength;
  final double borderWidth;
  final Color borderColor;
  final Color overlayColor;

  const ScannerOverlay(
      {super.key,
      this.cutOutSize = 220,
      this.borderLength = 30,
      this.borderWidth = 3,
      this.borderColor = Colors.white,
      this.overlayColor = const Color.fromARGB(171, 0, 0, 0)});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScannerOverlayPainter(
        cutOutSize: cutOutSize,
        borderLength: borderLength,
        borderWidth: borderWidth,
        borderColor: borderColor,
        overlayColor: overlayColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double cutOutSize;
  final double borderLength;
  final double borderWidth;
  final Color borderColor;
  final Color overlayColor;

  _ScannerOverlayPainter({
    required this.cutOutSize,
    required this.borderLength,
    required this.borderWidth,
    required this.borderColor,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final cutOutRect =
        Rect.fromCenter(center: center, width: cutOutSize, height: cutOutSize);

    // Затемнение
    paint.color = overlayColor;
    final fullRect = Offset.zero & size;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(fullRect),
        Path()..addRect(cutOutRect),
      ),
      paint,
    );

    // Углы рамки
    paint.color = borderColor;
    paint.strokeWidth = borderWidth;
    paint.style = PaintingStyle.stroke;

    final double left = cutOutRect.left;
    final double top = cutOutRect.top;
    final double right = cutOutRect.right;
    final double bottom = cutOutRect.bottom;

    // Левая верхняя
    canvas.drawLine(Offset(left, top), Offset(left + borderLength, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left, top + borderLength), paint);

    // Правая верхняя
    canvas.drawLine(
        Offset(right, top), Offset(right - borderLength, top), paint);
    canvas.drawLine(
        Offset(right, top), Offset(right, top + borderLength), paint);

    // Левая нижняя
    canvas.drawLine(
        Offset(left, bottom), Offset(left + borderLength, bottom), paint);
    canvas.drawLine(
        Offset(left, bottom), Offset(left, bottom - borderLength), paint);

    // Правая нижняя
    canvas.drawLine(
        Offset(right, bottom), Offset(right - borderLength, bottom), paint);
    canvas.drawLine(
        Offset(right, bottom), Offset(right, bottom - borderLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
