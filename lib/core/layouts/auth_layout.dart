import 'package:flutter/material.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/layouts/owner_tabs_layout.dart';
import 'package:glowguide/core/layouts/user_tabs_layout.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/admin/pages/admin_panel.dart';
import 'package:glowguide/features/auth/presentation/pages/sign_in_page.dart';
import 'package:glowguide/features/onboarding/pages/get_started_page.dart';
import 'package:glowguide/features/onboarding/pages/splash_page.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageInNotConnected});

  final Widget? pageInNotConnected;

  Future<Map<String, dynamic>> _getInitialData() async {
    final userType = await getIt<CacheHelper>().get(ApiKey.type);
    final isSeenOnboarding =
        getIt<CacheHelper>().get<bool>("SeenOnboarding") ?? false;
    return {
      'userType': userType,
      'isSeenOnboarding': isSeenOnboarding,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getInitialData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashPage();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SplashPage();
        }

        final userType = snapshot.data!['userType'];
        final isSeenOnboarding = snapshot.data!['isSeenOnboarding'];

        if (!isSeenOnboarding) {
          return const SplashPage();
        }

        if (userType == null) {
          return const GetStartedPage();
        }

        switch (userType) {
          case 'CO':
            return const OwnerTabsLayout();
          case 'U':
            return const UserTabsLayout();
          case 'A':
            return const AdminPanel();
          default:
            return pageInNotConnected ?? const SignInPage();
        }
      },
    );
  }
}
