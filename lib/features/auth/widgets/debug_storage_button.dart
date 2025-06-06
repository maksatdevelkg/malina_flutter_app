import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/features/auth/providers/auth_provider.dart';

class DebugStorageButton extends ConsumerWidget {
  const DebugStorageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final storage = ref.read(localStorageProvider);
        final emails = await storage.getAllUsers();

        for (final email in emails) {
          final password = storage.getPassword(email);
          final attempts = storage.getAttempts(email);
          final cart = storage.getCart(email);
          print('---');
          print('Email: $email');
          print('Пароль: $password');
          print('Попытки входа: $attempts');
          print('Корзина: $cart');
        }

        final current = await storage.getCurrentEmail();
        final isLoggedIn = await storage.isLoggedIn();

        print('Текущий пользователь: $current');
        print('Вход выполнен: $isLoggedIn');
      },
      child: const Text('Показать данные в консоли'),
    );
  }
}
