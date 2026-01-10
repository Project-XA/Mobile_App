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
    
    final hasCompletedOCR = await onboardingService.hasCompletedOCR();
    final isLoggedIn = await onboardingService.isLoggedIn();
    final hasCompleted = await onboardingService.hasCompletedOnboarding();
    
    String initialRoute;
    String? routeArgument;

    if (hasCompleted && isLoggedIn) {
      // User is registered and logged in → Go to main navigation
      final userRole = await onboardingService.getUserRole();
      initialRoute = Routes.mainNavigation;
      routeArgument = userRole ?? 'User';
    } else if (hasCompletedOCR) {
      // User completed OCR but not registered → Go to register screen
      initialRoute = Routes.registeScreen;
    } else {
      // Fresh start → Go to start page
      initialRoute = Routes.startPage;
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