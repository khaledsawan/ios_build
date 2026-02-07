import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/presentation/pages/details_tab.dart';
import 'package:glowguide/features/reviews/presentation/pages/tabs/reviews_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicDetailsPage extends StatelessWidget {
  final ClinicEntity clinic;

  const ClinicDetailsPage({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: clinic.clinicLogoUrl.isNotEmpty
                        ? Image.network(
                            clinic.clinicLogoUrl,
                            width: double.infinity,
                            height: 300.h,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(
                            height: 300.h,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 200,
                              ),
                            ),
                          ),
                  ),
                  Container(
                      color: Colors.black38,
                      width: double.infinity,
                      height: 300.h),
                  Positioned(
                    top: 44.h,
                    left: 16.w,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back,
                          size: 32.r, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -1,
                    child: Container(
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          clinic.clinicName,
                          style: AppTextStyles.heading01SemiBold,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 24,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                clinic.clinicAverageRating.toString(),
                                style: AppTextStyles.captionSemiBold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      clinic.clinicDescription,
                      style: AppTextStyles.paragraph02SemiBold.copyWith(
                        color: const Color(0xFF78808B),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 22,
                          color: AppColors.primary05,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          clinic.clinicLocation,
                          style: AppTextStyles.paragraph02Regular.copyWith(
                            color: const Color(0xFF78808B),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    DefaultTabController(
                      length: 2,
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
                                Center(child: Tab(text: "Details")),
                                Center(child: Tab(text: "Reviews")),
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
                              unselectedLabelStyle: AppTextStyles
                                  .paragraph02Regular
                                  .copyWith(color: const Color(0xFF78808B)),
                              dividerColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: 0.50.sh,
                            child: TabBarView(
                              children: [
                                DetailsTab(clinic: clinic),
                                ReviewsTab(clinic: clinic),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
