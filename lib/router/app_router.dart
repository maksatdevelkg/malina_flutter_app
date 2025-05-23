import 'package:go_router/go_router.dart';
import 'package:malina_flutter_app/features/add_product/add_product_page.dart';
import 'package:malina_flutter_app/features/auth/presentation/login_page.dart';
import 'package:malina_flutter_app/features/home/presentation/home_page.dart';
import 'package:malina_flutter_app/features/main_page.dart';
import 'package:malina_flutter_app/features/profile/presentation/profile_page.dart';
import 'package:malina_flutter_app/features/qr_scanner/presentation/qr_scanner_page.dart';

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

GoRoute(
  path: '/add-product/:category',
  builder: (context, state) {
    final category = state.pathParameters['category'] ?? 'Еда';
    return AddProductPage(initialCategory: category);
  },
),

GoRoute(
  path: '/qr-scanner',
  builder: (context, state) => const QrScannerPage(),
),

GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),

  ],
);