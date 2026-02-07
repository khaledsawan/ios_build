import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/admin/pages/tab/admin_clinics_tab.dart';
import 'package:glowguide/features/admin/pages/tab/admin_offers_tab.dart';
import 'package:glowguide/features/admin/pages/tab/admin_reviews_tab.dart';
import 'package:glowguide/features/auth/presentation/widgets/logout_button.dart';
import 'package:glowguide/features/notifications/presentation/pages/notifications_page.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              _appBar(context),
              SizedBox(height: 16.h),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7EAEE),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TabBar(
                          tabs: const [
                            Tab(text: "Clinics"),
                            Tab(text: "Reviews"),
                            Tab(text: "Offers"),
                          ],
                          labelColor: const Color(0xFF0D0F11),
                          unselectedLabelColor: const Color(0xFF707070),
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          indicatorPadding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: AppTextStyles.paragraph02Regular,
                          unselectedLabelStyle: AppTextStyles.paragraph02Regular
                              .copyWith(color: const Color(0xFF78808B)),
                          dividerColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            AdminClinicsTab(),
                            AdminReviewsTab(),
                            AdminOffersTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _appBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(AppAssets.logo, width: 32.w, height: 32.w),
            SizedBox(width: 8.w),
            const Text("GlowGuide", style: AppTextStyles.paragraph02SemiBold),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                );
              },
              icon: Icon(Icons.notifications_outlined, size: 32.r),
            ),
            const SizedBox(width: 4),
            const SignOutButton(),
          ],
        ),
      ],
    );
  }
}
