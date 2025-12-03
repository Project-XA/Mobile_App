import 'package:flutter/material.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/scan_id_screen.dart';
import 'package:mobile_app/feature/start_screen/start_page.dart';

class AppRoute {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.startPage:
        return MaterialPageRoute(builder: (_) => const StartPage());

      case Routes.scanIdScreen:
        return MaterialPageRoute(builder: (_) => const ScanIdScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
