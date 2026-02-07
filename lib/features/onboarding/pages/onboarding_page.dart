import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/onboarding/widgets/page_indicator.dart';
import 'package:glowguide/features/onboarding/pages/get_started_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = LiquidController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            LiquidSwipe(
              enableSideReveal: true,
              liquidController: controller,
              onPageChangeCallback: (index) {
                setState(() => currentPage = index);

                if (index == 3) {
                  getIt<CacheHelper>().save(key: "SeenOnboarding", value: true);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GetStartedPage(),
                    ),
                    (route) => false,
                  );
                }
              },
              slideIconWidget: Image.asset(AppAssets.skipIcon),
              pages: [
                _page(
                  backgroundColor: const Color(0xFFFFFFFF),
                  imageAsset: AppAssets.onboarding1,
                  bannerAsset: AppAssets.banner1,
                  title: "Welcome to GlowGuide 👋",
                  subtitle:
                      "Share your experience. Help others discover trusted beauty centers.",
                ),
                _page(
                  backgroundColor: const Color(0xFFC1DACA),
                  imageAsset: AppAssets.onboarding2,
                  bannerAsset: AppAssets.banner2,
                  title: "Tell your story ✍️",
                  subtitle:
                      "Write about your visit, rate the service, upload a photo and go on.",
                ),
                _page(
                  backgroundColor: const Color(0xFFFDEF8B),
                  imageAsset: AppAssets.onboarding3,
                  bannerAsset: AppAssets.banner3,
                  title: "Trusted by users 🎭",
                  subtitle:
                      "All submissions are reviewed for authenticity before they’re published.",
                ),
                Container(color: Colors.white),
              ],
            ),
            Positioned(
              bottom: 25.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [TwoDotIndicator(currentIndex: currentPage)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _page({
    required Color backgroundColor,
    required String imageAsset,
    required String bannerAsset,
    required String title,
    required String subtitle,
  }) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 375,
                ),
              ),
              Image.asset(
                bannerAsset,
                fit: BoxFit.fill,
                width: double.infinity,
                height: 375,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyles.heading01Bold),
                  SizedBox(height: 40.h),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Color(0xFF393E46),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
