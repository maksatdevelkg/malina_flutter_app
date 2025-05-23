import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/providers/cart_provider.dart';

class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({super.key});

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;
  CartItem? scannedItem;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _handleQrCode(Barcode scanData) {
    final code = scanData.code;
    if (code == null || isProcessing) return;
    isProcessing = true;
    controller?.pauseCamera();

    final parts = code.split('/');
    if (parts.length < 5) {
      showModalBottomSheet(
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
                onPressed: () {
                  Navigator.pop(context);
                  controller?.resumeCamera();
                  isProcessing = false;
                },
                child: const Text('Сканировать снова'),
              ),
            ],
          ),
        ),
      );
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
      imageUrl: _getImageForSubcategory(subcategory),
    );

    setState(() => scannedItem = item);
  }

  String _getImageForSubcategory(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'pizza':
        return 'assets/images/pizza_image.png';
      case 'tea':
        return 'assets/images/tea_image.png';
      case 'hot':
        return 'assets/images/hot_food.png';
      default:
        return 'assets/images/default_image.png';
    }
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
          QRView(
            key: qrKey,
            onQRViewCreated: (ctrl) {
              controller = ctrl;
              controller?.scannedDataStream.listen(_handleQrCode);
            },
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 220,
            ),
          ),
          const Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Поместите QR-код в рамку',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
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
                            scannedItem!.imageUrl ?? 'assets/images/default_image.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(scannedItem!.name,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(scannedItem!.description ?? '',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text('${scannedItem!.price} C',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          ref.read(cartProvider.notifier).addItem(scannedItem!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('«${scannedItem!.name}» добавлен в корзину')),
                          );
                          setState(() => scannedItem = null);
                          controller?.resumeCamera();
                          isProcessing = false;
                        },
                        child: const Text('Добавить', style: TextStyle(color: Colors.white)),
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
