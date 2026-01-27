import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminReviewsList extends StatelessWidget {
  const AdminReviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsStates>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ReviewsCubit>().getAllReviews();
          },
          child: _buildReviewsList(context, state),
        );
      },
    );
  }

  Widget _buildReviewsList(BuildContext context, ReviewsStates state) {
    if (state is GetAllReviewsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllReviewsFailed) {
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<ReviewsCubit>().getAllReviews();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text(state.errMessage),
              ),
            ),
          ],
        ),
      );
    }

    if (state is GetAllReviewsSuccessfully) {
      final reviews =
          state.reviews.where((r) => r.reviewStatus == "P").toList();

      return RefreshIndicator(
        onRefresh: () async {
          await context.read<ReviewsCubit>().getAllReviews();
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          itemCount: reviews.isEmpty ? 1 : reviews.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, index) {
            if (reviews.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: const Text("No Pending Reviews Currently!"),
                ),
              );
            }
            final review = reviews[index];
            return _reviewCard(context, review);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _reviewCard(BuildContext context, ReviewsEntity review) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ClinicDetailsPage(clinic: review.clinicDetails),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black26,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: review.userDetails.profilePic != null &&
                      review.userDetails.profilePic!.isNotEmpty
                  ? Image.network(
                      review.userDetails.profilePic!,
                      width: 45.w,
                      height: 45.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppAssets.userPlaceHolder,
                        width: 45.w,
                        height: 45.h,
                      ),
                    )
                  : Image.asset(
                      AppAssets.userPlaceHolder,
                      width: 45.w,
                      height: 45.h,
                    ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          review.userDetails.fullName,
                          style: AppTextStyles.paragraph02Regular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.star_rounded,
                        size: 18.r,
                        color: AppColors.secondary05,
                      ),
                      Text(
                        review.reviewRating.toString(),
                        style: AppTextStyles.captionSemiBold.copyWith(
                          color: AppColors.gary08,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    review.clinicDetails.clinicName,
                    style: AppTextStyles.paragraph02Regular.copyWith(
                      decoration: TextDecoration.underline,
                      color: AppColors.primary05,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "“${review.reviewContent}“",
                    style: AppTextStyles.paragraph02Regular.copyWith(
                      color: AppColors.gary08,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final params = AdminApproveRejectReviewParams(
                              reviewID: review.reviewID,
                              actionStatus: "A",
                            );
                            await context
                                .read<ReviewsCubit>()
                                .admingApproveRejectReview(params: params);
                            if (context.mounted) {
                              await context
                                  .read<ReviewsCubit>()
                                  .getAllReviews();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.success12,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                "Approve",
                                style: AppTextStyles.paragraph02Regular
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            final params = AdminApproveRejectReviewParams(
                              reviewID: review.reviewID,
                              actionStatus: "R",
                            );
                            context
                                .read<ReviewsCubit>()
                                .admingApproveRejectReview(params: params);

                            context.read<ReviewsCubit>().getAllReviews();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.error12,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                "Decline",
                                style: AppTextStyles.paragraph02Regular
                                    .copyWith(color: AppColors.error12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
