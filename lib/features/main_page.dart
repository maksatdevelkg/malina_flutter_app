import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/core/text_style/app_text_style.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/features/auth/providers/auth_provider.dart';
import 'package:malina_flutter_app/features/cart/presentation/cart_page.dart';
import 'package:malina_flutter_app/features/cart/riverpod/riverpod.dart';
import 'package:malina_flutter_app/features/home/presentation/home_page.dart';
import 'package:malina_flutter_app/features/profile/presentation/profile_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;
  final GlobalKey _cartKey = GlobalKey();
  bool _isScannerActive = false;
  OverlayEntry? _cartOverlay;

  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Избранное')),
    const SizedBox.shrink(),
    const ProfilePage(),
    const CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30)
          ]),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 4) {
                _toggleCartOverlay(ref);
              } else if (index != 2) {
                _removeOverlay();
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            selectedItemColor: AppColors.buttonColor,
            unselectedItemColor: AppColors.noActive,
            selectedLabelStyle: AppTextStyle.s10w500,
            unselectedLabelStyle: AppTextStyle.s10w500,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/feed_icon.png',
                  width: 25,
                  height: 25,
                  color: AppColors.noActive,
                ),
                activeIcon: Image.asset(
                  'assets/images/feed_icon.png',
                  width: 25,
                  height: 25,
                  color: AppColors.buttonColor,
                ),
                label: 'Лента',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Избранное',
              ),
              const BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/profile_icon.png',
                  width: 25,
                  height: 25,
                  color: AppColors.noActive,
                ),
                activeIcon: Image.asset(
                  'assets/images/profile_icon.png',
                  width: 25,
                  height: 25,
                  color: AppColors.buttonColor,
                ),
                label: 'Профиль',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  key: _cartKey,
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Корзина',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.buttonColor,
          ),
          child: IconButton(
            icon: _currentIndex == 0
                ? Image.asset(
                    'assets/images/scanner_icon.png',
                    width: 26,
                    height: 26,
                  )
                : Image.asset('assets/images/back_icon.png'),
            onPressed: () {
              if (_currentIndex == 0) {
                context.push('/qr-scanner');
              } else {
                setState(() {
                  _currentIndex = 0;
                });
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _toggleCartOverlay(WidgetRef ref) {
    final email = ref.read(localStorageProvider).getCurrentEmail();

    if (email == null) return;

    if (_cartOverlay != null) {
      _removeOverlay();
      return;
    }

    final contextBox = _cartKey.currentContext;
    if (contextBox == null) return;

    final RenderBox renderBox = contextBox.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    final cartItems = ref.read(cartProvider(email));

    final foodCount = cartItems
        .where((item) => item.category.toLowerCase() == 'food')
        .fold<int>(0, (sum, item) => sum + item.quantity);
    final beautyCount = cartItems
        .where((item) => item.category.toLowerCase() == 'beauty')
        .fold<int>(0, (sum, item) => sum + item.quantity);

    _cartOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned(
              left: position.dx + renderBox.size.width / 2 - 40,
              top: position.dy - 175,
              child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCartCircleButton(
                      imagePath: 'assets/images/food_icon.png',
                      label: 'Еда',
                      count: foodCount,
                      onTap: _navigateToCart,
                    ),
                    const SizedBox(height: 12),
                    _buildCartCircleButton(
                      imagePath: 'assets/images/cosmetic_icon.png',
                      label: 'Бьюти',
                      count: beautyCount,
                      onTap: _navigateToCart,
                    ),
                    const SizedBox(height: 10),
                    _buildCartCircleButton(
                      icon: Icons.shopping_cart,
                      label: 'Корзина',
                      onTap: _navigateToCart,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_cartOverlay!);
  }

  void _removeOverlay() {
    _cartOverlay?.remove();
    _cartOverlay = null;
  }

  void _navigateToCart() {
    _removeOverlay();
    setState(() {
      _currentIndex = 4;
    });
  }

  Widget _buildCartCircleButton({
    required String label,
    required VoidCallback onTap,
    String? imagePath,
    IconData? icon,
    int count = 0,
  }) {
    final isCart = label.toLowerCase() == 'корзина';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: isCart
                ? null
                : BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                    ],
                  ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imagePath != null)
                  Image.asset(imagePath, width: 24, height: 24)
                else if (icon != null)
                  Icon(icon, size: 24, color: AppColors.noActive),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isCart ? 10 : 10,
                    fontWeight: FontWeight.w500,
                    color: isCart ? AppColors.noActive : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.buttonColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
