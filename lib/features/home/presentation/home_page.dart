import 'package:flutter/material.dart';
import 'package:malina_flutter_app/core/text_style/app_text_style.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(right: 20, left: 20),
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
            Text('Скоро в Malina', style: AppTextStyle.s17w500),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSoonCard('Вакансии', Color(0xffD4E5FF)),
                  _buildSoonCard('Маркет', Color(0xffFFD3BA)),
                  _buildSoonCard('Цветы', Color(0xffFFDEDE)),
                  _buildSoonCard('Подарки', Color(0xffCFF2E3)),
                  _buildSoonCard('Финансы', Color(0xffBDE1D1)),
                  _buildSoonCard('Книги', Color(0xff7BB9C3)),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Искать в Malina',
        hintStyle: AppTextStyle.s14w400!.copyWith(color: AppColors.noActive),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.noActive,
        ),
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
        color: AppColors.buttonColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/image_qr.png',
            width: 36,
            height: 68,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text('Сканируй QR-код и \nзаказывай прямо в \nзаведении',
                style: AppTextStyle.s16w500!.copyWith(color: Colors.white)),
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(
                  imagePath,
                ),
                fit: BoxFit.cover,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.s22w600),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyle.s16w300),
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

  Widget _buildSoonCard(String title, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(title, style: AppTextStyle.s12w400),
        ),
      ),
    );
  }
}
