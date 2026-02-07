import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/widgets/top_rated_clinics.dart';
import 'package:glowguide/features/locations/presentation/widgets/user_main_location.dart';
import 'package:glowguide/features/notifications/presentation/widgets/notifications_button.dart';
import 'package:glowguide/features/offers/presentation/cubit/offers_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:glowguide/features/reviews/presentation/widgets/reviews_from_others.dart';
import 'package:glowguide/features/user/presentation/widgets/categories_selector.dart';
import 'package:glowguide/features/user/presentation/widgets/stack_carousel.dart';
import 'package:glowguide/features/user/presentation/widgets/user_search_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserHomeTab extends StatefulWidget {
  const UserHomeTab({super.key});

  @override
  State<UserHomeTab> createState() => _UserHomeTabState();
}

class _UserHomeTabState extends State<UserHomeTab> {
  String searchQuery = '';
  CategoryEntity? selectedCategory;
  List<String> selectedFilterCategories = [];
  List<int> selectedFilterRatings = [];

  final List<CategoryEntity> allCategories = [
    CategoryEntity(code: 'HC', name: 'HairCut'),
    CategoryEntity(code: 'SC', name: 'SkinCare'),
    CategoryEntity(code: 'MK', name: 'Makeup'),
    CategoryEntity(code: 'NL', name: 'Nails'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final futures = <Future>[];
            if (mounted) {
              futures.add(context.read<OffersCubit>().getAllOfferss());
            }
            if (context.mounted) {
              futures.add(context.read<ClinicsCubit>().getAllClinics());
            }
            if (context.mounted) {
              futures.add(context.read<ReviewsCubit>().getAllReviews());
            }
            await Future.wait(futures);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _appBar(context),
                  SizedBox(height: 8.h),
                  _searchBar(context),
                  SizedBox(height: 8.h),
                  const UserMainLocation(),
                  SizedBox(height: 16.h),
                  const StackCarousel(),
                  SizedBox(height: 24.h),
                  CategorySelector(
                    categories: allCategories,
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const Text(
                      "Top Rated Clinics",
                      style: AppTextStyles.paragraph02SemiBold,
                    ),
                  ),
                  TopRatedClinics(
                    searchQuery: searchQuery,
                    selectedCategory: selectedCategory,
                    filterCategories: selectedFilterCategories,
                    filterRatings: selectedFilterRatings,
                  ),
                  SizedBox(height: 8.h),
                  _reviewsFromOthers(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _reviewsFromOthers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const Text(
            "Reviews From Others",
            style: AppTextStyles.paragraph02SemiBold,
          ),
        ),
        const ReviewsFromOthers(),
      ],
    );
  }

  Padding _searchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFA5AEBB), width: 1),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 20.r,
                color: const Color(0xFF0D0F11),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    hintText: "Search...",
                    hintStyle: TextStyle(
                      color: Color(0xFF98A2B3),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              onPressed: () {
                showFilterBottomSheet(context);
              },
              icon: Icon(
                Icons.tune,
                size: 20.r,
                color: const Color(0xFF0D0F11),
              ),
            ),
          ],
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

  Future<void> showFilterBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 8.h,
            left: 16.w,
            right: 16.w,
            bottom: 60.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter",
                      style: AppTextStyles.paragraph01Regular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilterCategories = [];
                          selectedFilterRatings = [];
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Reset Filter",
                        style: AppTextStyles.paragraph02SemiBold.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary05,
                          color: AppColors.primary05,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Categories(
                  onSelected: (codes) {
                    setState(() {
                      selectedFilterCategories = codes;
                    });
                  },
                ),
                SizedBox(height: 24.h),
                Ratings(
                  onSelected: (ratings) {
                    setState(() {
                      selectedFilterRatings = ratings;
                    });
                  },
                ),
                SizedBox(height: 44.h),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
