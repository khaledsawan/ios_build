import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/reviews/presentation/widgets/admin_reviews_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminReviewsTab extends StatelessWidget {
  const AdminReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pending Reviews", style: AppTextStyles.paragraph01SemiBold),
        SizedBox(height: 16.h),
        const Expanded(child: AdminReviewsList()),
      ],
    );
  }
}
