import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/common/app_button.dart';
import 'package:malina_flutter_app/core/theme/gap.dart';
import 'package:malina_flutter_app/features/auth/providers/auth_provider.dart';
import 'package:malina_flutter_app/features/cart/riverpod/riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _debugPrintSavedPasswords();
    _emailController.addListener(() => setState(() {}));
  }

  void _debugPrintSavedPasswords() async {
    final storage = ref.read(localStorageProvider);
    final userList = await storage.getAllUsers();

    for (final email in userList) {
      final password = storage.getPassword(email);
      print('Пользователь: $email — пароль: $password');
    }
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        _emailError = 'Введите почту';
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(email)) {
        _emailError = 'Неверный формат почты';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Введите пароль';
      } else if (password.length < 8) {
        _passwordError = 'Минимум 8 символов';
      } else {
        _passwordError = null;
      }
    });
  }

  void _login() async {
    _validateEmail();
    _validatePassword();

    if (_emailError != null || _passwordError != null) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final storage = ref.read(localStorageProvider);

    final storedPassword = storage.getPassword(email);

    if (storedPassword == null) {
      await storage.saveEmail(email);
      await storage.savePassword(email, password);
      await storage.saveAttempts(email, 0);
      await storage.setLoggedIn(true);
      ref.read(cartProvider(email).notifier).loadCart(email);
      GoRouter.of(context).go('/main');
    } else {
      if (storedPassword == password) {
        await storage.saveAttempts(email, 0);
        await storage.saveEmail(email);
        await storage.setLoggedIn(true);
        ref.read(cartProvider(email).notifier).loadCart(email);
        GoRouter.of(context).go('/main');
      } else {
        int attempts = storage.getAttempts(email);
        attempts++;
        await storage.saveAttempts(email, attempts);

        if (attempts >= 3) {
          await storage.deleteUser(email);
          _showError('Пользователь удалён после 3 неудачных попыток входа');
        } else {
          _showError('Неверный пароль. Осталось попыток: ${3 - attempts}');
        }
      }
    }
    print('Attempts for $email: ${storage.getAttempts(email)}');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
//              TextButton(
//   onPressed: _debugPrintSavedPasswords,
//   child: Text('Посмотреть сохранённые пароли'),
// ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Почта',
                errorText: _emailError,
                suffixIcon: _emailController.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _emailController.clear();
                              });
                            },
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1.5,
                                  color: _emailError != null
                                      ? Theme.of(context).colorScheme.error
                                      : Colors.black,
                                ),
                                color: Color(0xffFAFAFB),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 15,
                                color: _emailError != null
                                    ? Theme.of(context).colorScheme.error
                                    : Colors.black,
                              ),
                            )),
                      )
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),

            Gap.h24,
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Пароль',
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),

            Gap.h24,
            AppButton(onPressed: _login, title: 'Войти'),
          ],
        ),
      ),
    );
  }
}
