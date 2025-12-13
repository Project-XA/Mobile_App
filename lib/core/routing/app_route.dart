import 'package:flutter/material.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/admin_home.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/profile_screen.dart';
import 'package:mobile_app/feature/register/presentation/register_screen.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/scan_id_screen.dart';
import 'package:mobile_app/feature/start_screen/start_page.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/registration_to_organization.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/home_page.dart';
import 'package:mobile_app/feature/profile/presentation/profile_page.dart';

class AppRoute {
  Route generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case Routes.startPage:
        page = const StartPage();
        break;

      case Routes.scanIdScreen:
        page = const ScanIdScreen();
        break;

      case Routes.registrationToOrganization:
        page = const RegistrationToOrganization();
        break;

      case Routes.homePage:
        final role = settings.arguments as String? ?? 'User';
        page = HomePage(userRole: role);
        break;

      case Routes.profilePage:
        page = const ProfilePage();
        break;
      case Routes.adminHome:
        page = const AdminHome();
        break;
      case Routes.profileScreen:
        page = const ProfileScreen();
        break;
      case Routes.registeScreen:
        page = const RegisterScreen();
        break;
      default:
        page = const Scaffold();
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
