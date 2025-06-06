import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/common/app_button.dart';
import 'package:malina_flutter_app/core/text_style/app_text_style.dart';
import 'package:malina_flutter_app/features/auth/providers/auth_provider.dart';
import 'package:malina_flutter_app/features/auth/widgets/debug_storage_button.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final storage = ref.read(localStorageProvider);
    await storage.clearUserData();
    if (context.mounted) {
      context.go('/login');
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final storage = ref.read(localStorageProvider);
    await storage.clearUserData();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Профиль',
          style: AppTextStyle.s20w700,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final storage = ref.read(localStorageProvider);
              await storage.logout();
              context.go('/login');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Text('Выйти', style: AppTextStyle.s14w400),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // DebugStorageButton(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<String?>(
              future: Future.value(ref.read(localStorageProvider).getEmail()),
              builder: (context, snapshot) {
                final email = snapshot.data ?? 'Гость';
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(email, style: AppTextStyle.s20w700),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: AppButton(
                onPressed: () => _deleteAccount(context, ref),
                title: 'Удалить'),
          )
        ],
      ),
    );
  }
}
