import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';
import 'package:malina_flutter_app/features/cart/providers/cart_provider.dart';

class CartItemCard extends ConsumerWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.subcategory.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  item.subcategory,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    image: item.imageUrl != null
                        ? DecorationImage(
                            image: item.imageUrl!.startsWith('http')
                                ? NetworkImage(item.imageUrl!) as ImageProvider
                                : AssetImage(item.imageUrl!),
                            fit: BoxFit.contain,
                          )
                        : null,
                  ),
                  child: item.imageUrl == null
                      ? const Icon(Icons.image_not_supported,
                          color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(item.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: 5,
                          ),
                          Text('${item.price} C',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600))
                        ],
                      ),
                      if (item.description != null)
                        Text(
                          item.description!,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => ref
                                    .read(cartProvider.notifier)
                                    .decrementQuantity(item.id),
                              ),
                              Text('${item.quantity}',
                                  style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => ref
                                    .read(cartProvider.notifier)
                                    .incrementQuantity(item.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                onPressed: () => ref
                                    .read(cartProvider.notifier)
                                    .removeItem(item.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
