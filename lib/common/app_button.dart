import 'package:flutter/material.dart';
import 'package:malina_flutter_app/core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  const AppButton(
      {required this.onPressed, required this.title, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(height ?? 50),
            backgroundColor: AppColors.buttonColor),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
