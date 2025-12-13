import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/feature/home/data/models/organization_model.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/home/data/models/user_org_model.dart';

List<CameraDescription> cameras = [];

Future<void> initializeApp() async {
  // Ensure Flutter bindings
  WidgetsFlutterBinding.ensureInitialized(); 

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserOrgModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(OrganizationModelAdapter());

  // Setup Dependency Injection
  await setup();

  // Initialize cameras
  try {
    cameras = await availableCameras();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing cameras: $e');
    }
  }
}
