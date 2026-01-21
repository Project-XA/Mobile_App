// core/routing/app_route.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/core/DI/init_current_user_di.dart';
import 'package:mobile_app/core/DI/init_user_home.dart';
import 'package:mobile_app/core/DI/register_get_it.dart';
import 'package:mobile_app/core/DI/scan_ocr_di.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/admin_home.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/profile_screen.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/home_page.dart';
import 'package:mobile_app/feature/navigation_screen/presentation/main_navigation_screen.dart';
import 'package:mobile_app/feature/register/presentation/register_screen.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/scan_id_screen.dart';
import 'package:mobile_app/feature/start_screen/start_page.dart';

class AppRoute {
  Route generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case Routes.startPage:
        page = const StartPage();
        break;

      case Routes.scanIdScreen:
        setupScanOcrFeature();
        page = const ScanIdScreen();
        break;

      case Routes.registeScreen:
        initRegister();
        page = const RegisterScreen();
        break;

      case Routes.mainNavigation:
        initCurrentUserDi();
        page = const MainNavigationScreen();
        break;

      case Routes.homePage:
        initUserHome();
        page = const HomePage();
        break;

      case Routes.adminHome:
        page = const AdminHome();
        break;

      case Routes.profileScreen:
        page = const ProfileScreen();
        break;

      default:
        page = const Scaffold(body: Center(child: Text('Route not found')));
    }

    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
