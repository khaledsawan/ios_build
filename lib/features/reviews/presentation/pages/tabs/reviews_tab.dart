import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_clinic_i_d_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_clinic_i_d_states.dart';
import 'package:glowguide/features/reviews/presentation/widgets/wtire_a_review_favorite_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsTab extends StatefulWidget {
  final ClinicEntity clinic;
  const ReviewsTab({super.key, required this.clinic});

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewsClinicIDCubit>().getAllReviewsByClinicID(
      GetReviewsByClinicIDParams(clinicID: widget.clinic.clinicId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReviewsClinicIDCubit, ReviewsClinicIDStates>(
        builder: (context, state) {
          if (state is GetAllReviewsByClinicIDLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetAllReviewsByClinicIDFailed) {
            return Center(
              child: Text(
                state.errMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph02Regular,
              ),
            );
          }

          if (state is GetAllReviewsByClinicIDSuccessfully) {
            final reviews = state.reviews;
            return _buildSuccessUI(reviews);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSuccessUI(List<ReviewsEntity> reviews) {
    return ListView(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      children: [
        SizedBox(height: 20.h),
        WtireAReviewFavoriteButtons(clinic: widget.clinic),
        SizedBox(height: 24.h),

        if (reviews.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.h),
            child: Center(
              child: Text(
                "There are no reviews for this clinic\nBe the first one!",
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph01Regular.copyWith(
                  color: AppColors.gary08,
                ),
              ),
            ),
          )
        else
          ...reviews.map(
            (review) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _reviewCard(review),
            ),
          ),

        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _reviewCard(ReviewsEntity review) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child:
                review.userDetails.profilePic != null &&
                    review.userDetails.profilePic!.isNotEmpty
                ? Image.network(
                    review.userDetails.profilePic!,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      AppAssets.userPlaceHolder,
                      width: 48.w,
                      height: 48.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    AppAssets.userPlaceHolder,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.cover,
                  ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userDetails.fullName,
                  style: AppTextStyles.paragraph01SemiBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 20.r, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      "${review.reviewRating}",
                      style: AppTextStyles.captionSemiBold.copyWith(
                        color: const Color(0xFF78808B),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                Text(
                  review.reviewContent,
                  style: AppTextStyles.paragraph02Regular.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
