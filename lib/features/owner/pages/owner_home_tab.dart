import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/notifications/presentation/widgets/notifications_button.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_states.dart';
import 'package:glowguide/features/reviews/presentation/widgets/recent_reviews_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_state.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';
import 'package:glowguide/features/offers/presentation/cubit/offers_cubit.dart';
import 'package:glowguide/features/offers/presentation/pages/create_offer_page.dart';

class OwnerHomeTab extends StatefulWidget {
  const OwnerHomeTab({super.key});

  @override
  State<OwnerHomeTab> createState() => _OwnerHomeTabState();
}

class _OwnerHomeTabState extends State<OwnerHomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Column(
              children: [
                _appBar(context),
                SizedBox(height: 8.h),
                _searchBar(),
                SizedBox(height: 16.h),
                _myClinics(),
                SizedBox(height: 16.h),
                _overViews(),
                SizedBox(height: 16.h),
                _recentReviews(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(AppAssets.logo, width: 32.w, height: 32.w),
              SizedBox(width: 8.w),
              const Text("GlowGuide", style: AppTextStyles.paragraph02SemiBold),
            ],
          ),
          const NotificationsButton(),
        ],
      ),
    );
  }

  Padding _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFA5AEBB), width: 1),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20.r, color: const Color(0xFF0D0F11)),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _myClinics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const Text("My Clinics",
              style: AppTextStyles.paragraph02SemiBold),
        ),
        BlocBuilder<ClinicsCubit, ClinicsState>(
          builder: (context, state) {
            if (state is GetClinicsLoading) {
              return const SizedBox(
                height: 130,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is GetClinicsFailed) {
              return const SizedBox(
                height: 130,
                child: Center(
                  child: Text(
                    "Couldn't fetch your clinics!\nPull to refresh",
                  ),
                ),
              );
            }

            if (state is GetClinicsSuccessfully) {
              List<ClinicEntity> clinics = state.clinics;

              if (searchQuery.isNotEmpty) {
                clinics = clinics
                    .where(
                      (clinic) => clinic.clinicName.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ),
                    )
                    .toList();
              }

              if (clinics.isEmpty) {
                return const SizedBox(
                  height: 130,
                  child: Center(child: Text("No clinics found")),
                );
              }

              return SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: clinics.length,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return _clinicCard(context, clinics[index]);
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _clinicCard(BuildContext context, ClinicEntity clinic) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClinicDetailsPage(clinic: clinic),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 1.sw - 32.w,
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: clinic.clinicLogoUrl != ""
                  ? Image.network(
                      clinic.clinicLogoUrl,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(
                      width: 96,
                      height: 96,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 96,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 22,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 2.5),
                      Text(
                        "${clinic.clinicAverageRating} ( ${clinic.clinicRatingCount} Reviews )",
                        style: AppTextStyles.footerRegular.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  clinic.clinicName,
                  style: AppTextStyles.paragraph01SemiBold.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 1.sw - 32.w - 96 - 32,
                  child: Text(
                    clinic.clinicDescription,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionRegular.copyWith(
                      color: const Color(0xFF393E46),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF7CAC8E),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      clinic.clinicLocation,
                      style: AppTextStyles.captionRegular.copyWith(
                        color: const Color(0xFF78808B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => OffersCubit(),
                          child: CreateOfferPage(clinicID: clinic),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Create Offer!",
                    style: AppTextStyles.paragraph01Regular.copyWith(
                      color: AppColors.error11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _overViews() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ReviewsCubit, ReviewsStates>(
        builder: (context, state) {
          if (state is GetAllReviewsLoading) {
            return const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is GetAllReviewsFailed) {
            return const Text("Failed to load reviews");
          }

          if (state is GetAllReviewsSuccessfully) {
            final reviews = state.reviews;

            final int publishedReviewsCount = reviews.length;

            final double averageRating = reviews.isEmpty
                ? 0
                : reviews.fold(0.0, (sum, r) => sum + r.reviewRating) /
                    reviews.length;

            final int totalRatings = reviews.length;

            return Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F1EA),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$publishedReviewsCount",
                              style: AppTextStyles.heading03Bold.copyWith(
                                fontSize: 36,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Published Reviews",
                          style: AppTextStyles.captionSemiBold.copyWith(
                            color: const Color(0xFF78808B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Rates Overview",
                          style: AppTextStyles.paragraph02SemiBold.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: averageRating.toStringAsFixed(1),
                                style: AppTextStyles.heading02Bold.copyWith(
                                  fontSize: 39,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.bottom,
                                child: Text(
                                  "/5",
                                  style: AppTextStyles.heading02Bold.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$totalRatings ratings",
                          style: AppTextStyles.captionSemiBold
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Column _recentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const Text(
            "Recent Reviews From Others",
            style: AppTextStyles.paragraph02SemiBold,
          ),
        ),
        const RecentReviewsCard(),
      ],
    );
  }
}
