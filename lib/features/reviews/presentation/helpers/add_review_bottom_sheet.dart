import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showWriteReviewBottomSheet(
  BuildContext context, {
  required ClinicEntity clinic,
  required TextEditingController controller,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return BlocProvider(
        create: (context) => ReviewsCubit(),
        child: _content(clinicId: clinic.clinicId, controller: controller),
      );
    },
  );
}

BlocConsumer<ReviewsCubit, ReviewsStates> _content({
  required String clinicId,
  required TextEditingController controller,
}) {
  return BlocConsumer<ReviewsCubit, ReviewsStates>(
    listener: (context, state) {
      if (state is WriteReviewSuccessfully) {
        Navigator.pop(context);

        CustomScaffoldMessenger().showSuccess(
          "Your review was submitted successfully!\nWait for admin approval to see your review..",
        );
      }
    },
    builder: (context, state) {
      final isLoading = state is WriteReviewLoading;
      String? errorMessage;

      if (state is WriteReviewFailed) {
        errorMessage = state.errMessage;
      }

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
              _header(context),
              SizedBox(height: 16.h),
              const RateSelector(),
              SizedBox(height: 16.h),
              _yourReview(errorMessage: errorMessage, controller: controller),
              SizedBox(height: 44.h),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final String? selectedRatingStr =
                            getIt<CacheHelper>().get("SelectedRating");

                        final int rating =
                            int.tryParse(selectedRatingStr ?? '') ?? 0;

                        final params = WriteReviewParams(
                          clinicID: clinicId,
                          rating: rating,
                          reviewText: controller.text.trim(),
                        );

                        context.read<ReviewsCubit>().writeNewReview(params);

                        getIt<CacheHelper>().remove("SelectedRating");
                      },
                style: isLoading
                    ? Theme.of(context).elevatedButtonTheme.style!.copyWith(
                          backgroundColor: WidgetStateProperty.all(Colors.grey),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                    : null,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Confirm"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Column _yourReview({
  String? errorMessage,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Your Review",
        style: AppTextStyles.paragraph02Regular.copyWith(
          color: const Color(0xFF0D0F11),
        ),
      ),
      SizedBox(height: 8.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 18.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFA5AEBB), width: 0.5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: TextField(
          maxLines: 7,
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter ...",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
      if (errorMessage != null) ...[
        SizedBox(height: 8.h),
        Text(
          errorMessage,
          style: const TextStyle(color: AppColors.error12, fontSize: 14),
        ),
      ],
    ],
  );
}

class RateSelector extends StatefulWidget {
  const RateSelector({super.key});

  @override
  State<RateSelector> createState() => _RateSelectorState();
}

class _RateSelectorState extends State<RateSelector> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Rate",
          style: AppTextStyles.paragraph02Regular.copyWith(
            color: const Color(0xFF0D0F11),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFA5AEBB), width: 0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = starIndex;

                    getIt<CacheHelper>().save(
                      key: "SelectedRating",
                      value: selectedRating.toString(),
                    );
                  });
                },
                child: Icon(
                  starIndex <= selectedRating
                      ? Icons.star
                      : Icons.star_border_rounded,
                  size: 30.r,
                  color: Colors.amber,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

Row _header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Share Your Experience !",
        style: AppTextStyles.paragraph01Regular.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      GestureDetector(
        onTap: () {},
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: AppTextStyles.paragraph02SemiBold.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary05,
              color: AppColors.primary05,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    ],
  );
}
