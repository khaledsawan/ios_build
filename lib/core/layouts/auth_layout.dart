import 'package:flutter/material.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/layouts/owner_tabs_layout.dart';
import 'package:glowguide/core/layouts/user_tabs_layout.dart';
import 'package:glowguide/core/singleton/injection_container.dart';
import 'package:glowguide/features/admin/pages/admin_panel.dart';
import 'package:glowguide/features/auth/presentation/pages/sign_in_page.dart';
import 'package:glowguide/features/onboarding/pages/get_started_page.dart';
import 'package:glowguide/features/onboarding/pages/splash_page.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key, this.pageInNotConnected});

  final Widget? pageInNotConnected;

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  bool _cacheReady = false;

  @override
  void initState() {
    super.initState();
    _checkCacheReady();
  }

  Future<void> _checkCacheReady() async {
    // Wait until CacheHelper is initialized
    try {
      // Try to access cache to see if it's ready
      await sl<CacheHelper>().getData(key: 'dummy');
      if (mounted) {
        setState(() {
          _cacheReady = true;
        });
      }
    } catch (e) {
      // If not ready, wait a bit and try again
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        _checkCacheReady();
      }
    }
  }

  Future<Map<String, dynamic>> _getInitialData() async {
    final userType = await sl<CacheHelper>().getData(key: ApiKey.type);
    final isSeenOnboarding =
        await sl<CacheHelper>().getData(key: "SeenOnboarding") ?? false;

    return {
      'userType': userType,
      'isSeenOnboarding': isSeenOnboarding,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_cacheReady) {
      return const SplashPage();
    }

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
            return widget.pageInNotConnected ?? const SignInPage();
        }
      },
    );
  }
}
