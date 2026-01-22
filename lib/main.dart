import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/curren_user/Data/Auth_services/auth_state_model.dart';
import 'package:mobile_app/core/app_boot_strap.dart';
import 'package:mobile_app/core/curren_user/Data/models/organization_model.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_org_model.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthStateModelAdapter());

  Hive.registerAdapter(UserOrgModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(OrganizationModelAdapter());

  runApp(const AppBootstrap());
}
