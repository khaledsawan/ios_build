import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/admin/pages/tab/sub_tabs/current_clinic_sub_tab.dart';
import 'package:glowguide/features/admin/pages/tab/sub_tabs/pending_clinics_sub_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminClinicsTab extends StatelessWidget {
  const AdminClinicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                tabs: const [
                  Tab(text: "Current"),
                  Tab(text: "Pending"),
                ],
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.primary05,
                indicator: BoxDecoration(
                  color: AppColors.primary05,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 8.w),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: AppTextStyles.paragraph02Regular,
                unselectedLabelStyle: AppTextStyles.paragraph02Regular.copyWith(
                  color: const Color(0xFF78808B),
                ),
                dividerColor: Colors.transparent,
              ),
            ),
          ),
        ],
        body: const TabBarView(
          children: [CurrentClinicSubTab(), PendingClinicsSubTab()],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.primary05),
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
