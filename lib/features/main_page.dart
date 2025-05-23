import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/features/cart/cart_page.dart';
import 'package:malina_flutter_app/features/cart/providers/cart_provider.dart';
import 'package:malina_flutter_app/features/home/presentation/home_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;
  final GlobalKey _cartKey = GlobalKey();
  OverlayEntry? _cartOverlay;

  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Избранное')),
    const SizedBox.shrink(),
    const Center(child: Text('Профиль')),
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
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 4) {
              _toggleCartOverlay(ref);
            } else if (index != 2) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.list), label: 'Лента'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Избранное'),
            const BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Профиль'),
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
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: () {
              context.push('/qr-scanner');
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _toggleCartOverlay(WidgetRef ref) {
    if (_cartOverlay != null) {
      _cartOverlay?.remove();
      _cartOverlay = null;
      return;
    }

    final RenderBox renderBox =
        _cartKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    final cartItems = ref.read(cartProvider);
    final foodCount = cartItems
        .where((item) => item.category.toLowerCase() == 'food')
        .fold<int>(0, (sum, item) => sum + item.quantity);
    final beautyCount = cartItems
        .where((item) => item.category.toLowerCase() == 'beauty')
        .fold<int>(0, (sum, item) => sum + item.quantity);

    _cartOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _cartOverlay?.remove();
          _cartOverlay = null;
        },
        child: Stack(
          children: [
            Positioned(
              left: position.dx - 35 + renderBox.size.width / 2,
              top: position.dy - 160,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCartCircleButton(
                      icon: Icons.fastfood,
                      label: 'Еда',
                      count: foodCount,
                      onTap: () {
                        _cartOverlay?.remove();
                        _cartOverlay = null;
                        setState(() {
                          _currentIndex = 4;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildCartCircleButton(
                      icon: Icons.spa,
                      label: 'Бьюти',
                      count: beautyCount,
                      onTap: () {
                        _cartOverlay?.remove();
                        _cartOverlay = null;
                        setState(() {
                          _currentIndex = 4;
                        });
                      },
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

  Widget _buildCartCircleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    int count = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(height: 4),
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
          ),
          if (count > 0)
            Positioned(
              right: 0,
              top: -4,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text('$count',
                    style: const TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}
