import 'package:go_router/go_router.dart';
import 'package:multi_vendor/models/api/category_api_models.dart';
import 'package:multi_vendor/screen/authentication/login_auth_screen.dart';
import 'package:multi_vendor/screen/authentication/register_auth_screen.dart';
import 'package:multi_vendor/screen/authentication/seller/seller_auth_screen.dart';
import 'package:multi_vendor/screen/authentication/seller/seller_login_auth_screen.dart';
import 'package:multi_vendor/screen/user/home_user_screen.dart';
import 'package:multi_vendor/utils/routes/splash_screen_route.dart';

import '../../screen/authentication/seller/seller_bank_detail_screen.dart';
import '../../screen/authentication/seller/seller_tax_detail_screen.dart';
import '../../screen/seller/web_seller_screen.dart';
import '../../screen/user/widget/inner_category_widget_user.dart';
import '../../screen/user/widget/navigation/category_navigation_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreenRoute(),
      ),
      GoRoute(
        path: '/loginPage',
        builder: (context, state) => const LoginAuthScreen(),
      ),
      GoRoute(
        path: '/registerPage',
        builder: (context, state) => const RegisterAuthScreen(),
      ),
      GoRoute(
        path: '/sellerPage',
        builder: (context, state) => const SellerAuthScreen(),
      ),
      GoRoute(
        path: '/sellerLoginPage',
        builder: (context, state) => const SellerLoginAuthScreen(),
      ),
      GoRoute(
        path: '/sellerTaxDetailPage',
        builder: (context, state) {
          return const SellerTaxDetailScreen();
        },
      ),
      GoRoute(
        path: '/sellerBankDetailPage',
        builder: (context, state) {
          return const SellerBankDetailScreen();
        },
      ),
      GoRoute(
        path: '/homePage',
        builder: (context, state) => HomeUserScreen(),
      ),
      GoRoute(
        path: '/categoryPage',
        builder: (context, state) => CategoryNavigationScreen(hasAppBar: true),
      ),
      GoRoute(
        path: '/innerCategoryPage',
        builder: (context, state) {
          final category = state.extra as CategoryApiModels;
          return InnerCategoryScreen(category: category);
        },
      ),
      GoRoute(
        path: '/management',
        builder: (context, state) => const WebDeviceView(),
      ),
    ],
  );
}
