import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/features/auth/presentation/login_page.dart';
import 'package:malina_flutter_app/features/home/presentation/home_page.dart';
import 'package:malina_flutter_app/features/main_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
  path: '/main',
  builder: (context, state) => const MainPage(),
),
  ],
);