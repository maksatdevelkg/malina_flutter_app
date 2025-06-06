import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:malina_flutter_app/core/text_style/app_text_style.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/features/cart/domain/models/cart_item.dart';


import '../riverpod/riverpod.dart';

class CartItemCard extends ConsumerWidget {
  final CartItem item;
  final String email;

  const CartItemCard({
    super.key,
    required this.item,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = item.price * item.quantity;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (item.subcategory.isNotEmpty)
              Row(
                children: [
                  Text(item.subcategory,
                      style: AppTextStyle.s16w400!
                          .copyWith(color: const Color(0xff5F5F5F))),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            const Divider(
              color: Color(0xffEDEBEB),
              thickness: 1,
              height: 20,
              indent: 10,
              endIndent: 10,
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.backgroundColor,
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
                      ? const Icon(Icons.image_not_supported, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(item.name, style: AppTextStyle.s16w500),
                          ),
                          const SizedBox(width: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${item.price} ',
                                  style: AppTextStyle.s16w500,
                                ),
                                TextSpan(
                                  text: 'С',
                                  style: AppTextStyle.s16w500!.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (item.description != null)
                        Text(
                          item.description!,
                          style: AppTextStyle.s12w400!
                              .copyWith(color: const Color(0xff777777)),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _quantityButton(
                            icon: Icons.remove,
                            onTap: () => ref.read(cartProvider(email).notifier).decrement(item)
                          ),
                          const SizedBox(width: 10),
                          Text('${item.quantity}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          _quantityButton(
                            icon: Icons.add,
                           onTap: () => ref.read(cartProvider(email).notifier).decrement(item),),
                          const Spacer(),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/delete_icon.png',
                              width: 35,
                              height: 35,
                            ),
                            onPressed: () => ref.read(cartProvider(email).notifier).removeItem(item),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (item.category.toLowerCase() == 'food') ...[
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundColor,
                        border: Border.all(
                          color: const Color(0xff00B866),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xff00B866),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text('Добавки', style: AppTextStyle.s16w400),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            Container(
              height: 60,
              width: 310,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.buttonColor,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Всего',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$total ',
                            style: AppTextStyle.s16w500!
                                .copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'С',
                            style: AppTextStyle.s16w500!.copyWith(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.backgroundColor,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18),
        onPressed: onTap,
      ),
    );
  }
}
