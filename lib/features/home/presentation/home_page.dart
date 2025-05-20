import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildQrCard(),
            const SizedBox(height: 20),
            _buildCategoryCard(
              title: 'Еда',
              subtitle: 'Из кафе \nи ресторанов',
              imagePath: 'assets/images/food.png',
              color: Colors.amber.shade100,
            ),
            const SizedBox(height: 20),
            _buildCategoryCard(
              title: 'Бьюти',
              subtitle: 'Салоны красоты \nи товары',
              imagePath: 'assets/images/beauty.png',
              color: Colors.pink.shade100,
            ),
            const SizedBox(height: 12),
            const Text('Скоро в Malina',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSoonCard('Вакансии'),
                  _buildSoonCard('Маркет'),
                  _buildSoonCard('Цветы'),
                  _buildSoonCard('Подарки'),
                  _buildSoonCard(''),
                  _buildSoonCard('Книги'),
                ],
              ),
            ),
          ],
        ),
      ),
     
    );
  }

  Widget _buildSearchBar() {
    return const TextField(
      decoration: InputDecoration(
        hintText: 'Искать в Malina',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildQrCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.qr_code, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Сканируй QR-код и заказывай прямо в заведении',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color color,
  }) {
    return Stack(
      children: [
        Container(
          height: 170,
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Image.asset(
          imagePath,
          height: 170,
          width: 350,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoonCard(String title) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
