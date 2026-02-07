import 'dart:async';
import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/onboarding/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary08,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.logo, width: 150, height: 150),
            SizedBox(height: 20.h),
            Text(
              "GlowGuide",
              style: AppTextStyles.heading01SemiBold.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              "The Preview Room",
              style: AppTextStyles.paragraph01Regular.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            const CircularProgressIndicator(color: AppColors.secondary04),
          ],
        ),
      ),
    );
  }
}
