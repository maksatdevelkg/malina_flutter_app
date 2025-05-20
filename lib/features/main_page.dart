import 'package:flutter/material.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';
import 'package:malina_flutter_app/features/cart/cart_page.dart';
import 'package:malina_flutter_app/features/home/presentation/home_page.dart';
import 'package:malina_flutter_app/features/cart/pages/add_product_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

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
            if (index != 2) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Лента'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Избранное'),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Корзина'),
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
            onPressed: () {},
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
