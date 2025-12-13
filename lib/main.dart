import 'package:flutter/material.dart';
import 'package:mobile_app/attendency_app.dart';
import 'package:mobile_app/core/app_initializer.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/routing/routes.dart';

Future<void> main() async {
  await initializeApp();

  runApp(
    AttendencyApp(appRouter: AppRoute(), initialRoute: Routes.registeScreen),
  );
}
