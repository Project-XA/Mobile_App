import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_admin_home.dart';
import 'package:mobile_app/core/DI/init_user_home.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/admin_home.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/profile_screen.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/home_page.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CurrentUserCubit>()..loadUser(),
      child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
        builder: (context, state) {
          // Loading State
          if (state is CurrentUserLoading || state is CurrentUserInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Error State
          if (state is CurrentUserError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Occurred',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CurrentUserCubit>().loadUser(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success - Get role and show appropriate navigation
          final cubit = context.read<CurrentUserCubit>();
          final role = cubit.role;

          if (role == null) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }

          // Initialize based on role
          if (role.toLowerCase() == 'admin') {
            initAdminHome();
          } else {
            initUserHome();
          }
          // Show the actual navigation
          return _MainNavigationContent(isAdmin: role.toLowerCase() == 'admin');
        },
      ),
    );
  }
}

// Separate widget for the actual navigation content
class _MainNavigationContent extends StatefulWidget {
  final bool isAdmin;

  const _MainNavigationContent({required this.isAdmin});

  @override
  State<_MainNavigationContent> createState() => _MainNavigationContentState();
}

class _MainNavigationContentState extends State<_MainNavigationContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      widget.isAdmin ? const AdminHome() : const HomePage(),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.mainTextColorBlack,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24.sp),
            activeIcon: Icon(Icons.home, size: 26.sp),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24.sp),
            activeIcon: Icon(Icons.person, size: 26.sp),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
