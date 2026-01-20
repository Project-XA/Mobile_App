import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/app_boot_strap.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/auth_state_model.dart';
import 'package:mobile_app/feature/home/data/models/organization_model.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/home/data/models/user_org_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthStateModelAdapter());
  Hive.registerAdapter(UserOrgModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(OrganizationModelAdapter());

  runApp(const AppBootstrap());
}
