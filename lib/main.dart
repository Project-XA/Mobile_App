import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/attendency_app.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/routing/routes.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    cameras = await availableCameras();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing cameras: $e');
    }
  }
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AttendencyApp(appRouter: AppRoute(), initialRoute: Routes.homePage));
}
