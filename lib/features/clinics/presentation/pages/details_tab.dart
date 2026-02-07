import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/reviews/presentation/widgets/wtire_a_review_favorite_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTab extends StatelessWidget {
  final ClinicEntity clinic;

  final List<Color> bgColors = const [
    Color(0xFFE2ECF7),
    Color(0xFFDAF6E1),
    Color(0xFFFDF8C4),
    Color(0xFFFFC0FE),
  ];

  final List<Color> textColors = const [
    Color(0xFF4064B5),
    Color(0xFF2FCC55),
    Color(0xFFE7B20B),
    Color(0xFFB700B4),
  ];

  const DetailsTab({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    clinic.clinicCategories.map((e) => e.name).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Who are we !?", style: AppTextStyles.paragraph01SemiBold),
            SizedBox(height: 8.h),
            Text(
              clinic.clinicWhoAreWe,
              style: AppTextStyles.paragraph01Regular.copyWith(
                color: const Color(0xFF6B6B6B),
              ),
            ),
            SizedBox(height: 16.h),
            const Text("What we provide !", style: AppTextStyles.paragraph01SemiBold),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(clinic.clinicCategories.length, (index) {
                final category = clinic.clinicCategories[index];

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 9.h,
                  ),
                  decoration: BoxDecoration(
                    color: bgColors[index % bgColors.length],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    category.name,
                    style: AppTextStyles.paragraph02Regular.copyWith(
                      color: textColors[index % textColors.length],
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 32.h),
            WtireAReviewFavoriteButtons(clinic: clinic),
          ],
        ),
      ),
    );
  }
}
