import 'package:flutter/material.dart';
import 'package:mobile_app/attendency_app.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/onboarding_service.dart';
import 'package:mobile_app/feature/splash/animated_splash_screen.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _showAnimatedSplash = true;
  bool _isInitialized = false;
  String? _initialRoute;
  String? _routeArgument;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await initCore();

    final onboardingService = getIt<OnboardingService>();
    
    // ⭐ Check states
    final hasCompletedOCR = await onboardingService.hasCompletedOCR();
    final hasRegistered = await onboardingService.hasCompletedOnboarding();
    final isLoggedIn = await onboardingService.isLoggedIn();

    String initialRoute;
    String? routeArgument;

    // ⭐ Decision tree based on token
    if (!hasCompletedOCR) {
      // Fresh user → Start page (OCR)
      initialRoute = Routes.startPage;
    } else if (!hasRegistered) {
      // Has OCR data but not registered → Register screen
      initialRoute = Routes.registeScreen;
    } else if (!isLoggedIn) {
      // Has registration but no token → Register screen (for quick login)
      initialRoute = Routes.registeScreen;
    } else {
      // Has valid token → Main navigation
      final userRole = await onboardingService.getUserRole();
      initialRoute = Routes.mainNavigation;
      routeArgument = userRole ?? 'User';
    }

    setState(() {
      _initialRoute = initialRoute;
      _routeArgument = routeArgument;
      _isInitialized = true;
    });
  }

  void _onAnimationComplete() {
    setState(() {
      _showAnimatedSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show animated splash while loading
    if (!_isInitialized || _showAnimatedSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(onAnimationComplete: _onAnimationComplete),
      );
    }

    return AttendencyApp(
      appRouter: AppRoute(),
      initialRoute: _initialRoute!,
      initialRouteArguments: _routeArgument,
    );
  }
}