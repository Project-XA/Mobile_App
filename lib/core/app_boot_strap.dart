import 'package:flutter/material.dart';
import 'package:mobile_app/attendency_app.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/routing/routes.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await initCore();

    runApp(AttendencyApp(appRouter: AppRoute(), initialRoute: Routes.homePage));
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
