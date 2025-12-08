import 'package:flutter/material.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/scan_id_screen.dart';
import 'package:mobile_app/feature/start_screen/start_page.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/registration_to_organization.dart';
import 'package:mobile_app/feature/home/presentation/home_page.dart';
import 'package:mobile_app/feature/profile/presentation/profile_page.dart';

class AppRoute {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.startPage:
        return MaterialPageRoute(builder: (_) => const StartPage());

      case Routes.scanIdScreen:
        return MaterialPageRoute(builder: (_) => const ScanIdScreen());
      case Routes.registrationToOrganization:
        return MaterialPageRoute(builder: (_) => RegistrationToOrganization());
      case Routes.homePage:
        final role = settings.arguments as String? ?? 'User';
        return MaterialPageRoute(builder: (_) => HomePage(userRole: role));
      case Routes.profilePage:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
