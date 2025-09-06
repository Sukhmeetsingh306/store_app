import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:multi_vendor/models/api/category_api_models.dart';
import 'package:multi_vendor/screen/authentication/login_auth_screen.dart';
import 'package:multi_vendor/screen/authentication/register_auth_screen.dart';
import 'package:multi_vendor/screen/authentication/seller/seller_auth_screen.dart';
import 'package:multi_vendor/screen/authentication/seller/seller_login_auth_screen.dart';
import 'package:multi_vendor/screen/user/home_user_screen.dart';
import 'package:multi_vendor/utils/routes/splash_screen_route.dart';

import '../../models/product_model.dart';
import '../../screen/authentication/seller/seller_bank_detail_screen.dart';
import '../../screen/authentication/seller/seller_tax_detail_screen.dart';
import '../../screen/seller/user_seller_screen.dart';
import '../../screen/seller/web_seller_screen.dart';
import '../../screen/user/widget/inner_category_widget_user.dart';
import '../../screen/user/widget/navigation/category_navigation_screen.dart';
import '../../screen/user/widget/support/product/product_detail_support_widget.dart';

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
        builder: (context, state) {
          return state.extra is! LoginAuthScreen
              ? const LoginAuthScreen()
              : state.extra as LoginAuthScreen;
        },
      ),
      GoRoute(
        path: '/registerPage',
        builder: (context, state) {
          return state.extra is! RegisterAuthScreen
              ? const RegisterAuthScreen()
              : state.extra as RegisterAuthScreen;
        },
      ),
      GoRoute(
        path: '/sellerPage',
        builder: (context, state) {
          return state.extra is! SellerAuthScreen
              ? const SellerAuthScreen()
              : state.extra as SellerAuthScreen;
        },
      ),
      GoRoute(
        path: '/sellerLoginPage',
        builder: (context, state) {
          return state.extra is! SellerLoginAuthScreen
              ? const SellerLoginAuthScreen()
              : state.extra as SellerLoginAuthScreen;
        },
      ),
      GoRoute(
        path: '/sellerTaxDetailPage',
        builder: (context, state) {
          return state.extra is! SellerTaxDetailScreen
              ? const SellerTaxDetailScreen()
              : state.extra as SellerTaxDetailScreen;
        },
      ),
      GoRoute(
        path: '/sellerBankDetailPage',
        builder: (context, state) {
          return state.extra is! SellerBankDetailScreen
              ? const SellerBankDetailScreen()
              : state.extra as SellerBankDetailScreen;
        },
      ),
      GoRoute(
        path: '/homePage',
        builder: (context, state) {
          return state.extra is! HomeUserScreen
              ? HomeUserScreen()
              : state.extra as HomeUserScreen;
        },
      ),
      GoRoute(
        path: '/categoryPage',
        builder: (context, state) {
          return state.extra is! CategoryNavigationScreen
              ? CategoryNavigationScreen(hasAppBar: true)
              : state.extra as CategoryNavigationScreen;
        },
      ),
      GoRoute(
        path: '/management',
        builder: (context, state) {
          return state.extra is! WebDeviceView
              ? const WebDeviceView()
              : state.extra as WebDeviceView;
        },
      ),
      GoRoute(
        path: '/seller/dashboard',
        builder: (context, state) {
          return state.extra is! UserSellerScreen
              ? const UserSellerScreen()
              : state.extra as UserSellerScreen;
        },
      ),
      GoRoute(
        path: '/category/:categoryName',
        builder: (context, state) {
          // Try to use extra first
          final extraCategory = state.extra as CategoryApiModels?;
          if (extraCategory != null) {
            return InnerCategoryScreen(category: extraCategory);
          }

          // Fallback: build category from path param
          final categoryName = state.pathParameters['categoryName']!;
          final category = CategoryApiModels(
            categoryId: '',
            categoryName: categoryName,
            categoryImage: '',
            categoryBanner: '',
          );
          return InnerCategoryScreen(category: category);
        },
      ),
      GoRoute(
        path: '/product/productDetail/:productName',
        builder: (context, state) {
          final extra = state.extra;

          ProductModel? product;

          if (extra != null) {
            if (extra is ProductModel) {
              // Already a ProductModel
              product = extra;
            } else if (extra is Map<String, dynamic>) {
              // Got a Map, convert to ProductModel
              product = ProductModel.fromProduct(extra);
            } else if (extra is String) {
              // Got a JSON string, decode first
              final decoded = jsonDecode(extra);

              if (decoded is Map<String, dynamic>) {
                product = ProductModel.fromProduct(decoded);
              }
            }
          }

          // If still null, fallback with just productName
          product ??= ProductModel(
            id: '',
            productName: state.pathParameters['productName'] ?? 'Unknown',
            productPrice: 0,
            productQuantity: 0,
            productDescription: '',
            sellerId: '',
            sellerName: '',
            productCategory: '',
            productSubCategory: null,
            productImage: [],
            productPopularity: false,
            productRecommended: false,
          );

          return ProductDetailSupportWidget(product: product);
        },
      ),
    ],
  );
}
