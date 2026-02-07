import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';
import 'package:glowguide/features/reviews/domain/entities/reviews_entity.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsFromOthers extends StatelessWidget {
  const ReviewsFromOthers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsStates>(
      builder: (context, state) {
        if (state is GetAllReviewsLoading) {
          return const SizedBox(
            height: 130,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is GetAllReviewsFailed) {
          return const Center(
            child: Text("Couldn't fetch reviews!\nPull to refresh"),
          );
        }

        if (state is GetAllReviewsSuccessfully) {
          final reviews = state.reviews;

          if (reviews.isEmpty) {
            return const SizedBox(
              height: 130,
              child: Center(child: Text("No Current Reviews")),
            );
          }
        }

        if (state is GetAllReviewsSuccessfully) {
          final fetchedReviews = state.reviews;

          return SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: fetchedReviews.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final reviews = fetchedReviews[index];
                return _reviewCard(context, reviews);
              },
            ),
          );
        } else {
          return const SizedBox(height: 100);
        }
      },
    );
  }

  Widget _reviewCard(BuildContext context, ReviewsEntity reviews) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ClinicDetailsPage(clinic: reviews.clinicDetails),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 300.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
              borderRadius: BorderRadius.circular(10000),
              child: reviews.userDetails.profilePic != null &&
                      reviews.userDetails.profilePic!.isNotEmpty
                  ? Image.network(
                      reviews.userDetails.profilePic!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppAssets.userPlaceHolder,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      AppAssets.userPlaceHolder,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          reviews.userDetails.fullName,
                          style: AppTextStyles.paragraph01SemiBold.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 1.5,
                          horizontal: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(color: Colors.amber, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              reviews.reviewRating.toString(),
                              style: AppTextStyles.footerRegular,
                            ),
                            const SizedBox(width: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(reviews.clinicDetails.clinicName,
                      style: AppTextStyles.captionRegular.copyWith(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(
                    "“${reviews.reviewContent}",
                    style: AppTextStyles.captionRegular.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
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
