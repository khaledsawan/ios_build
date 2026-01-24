import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCurrentLocations extends StatefulWidget {
  const UserCurrentLocations({super.key});

  @override
  State<UserCurrentLocations> createState() => _UserCurrentLocationsState();
}

class _UserCurrentLocationsState extends State<UserCurrentLocations> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsCubit, LocationsStates>(
      builder: (context, state) {
        if (state is GetAllLocationsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetAllLocationsFailed) {
          return Text(state.errMessage);
        }

        if (state is GetAllLocationsSuccessfully) {
          final locations = state.location;

          if (_selectedIndex == null) {
            final defaultIndex = locations.indexWhere((loc) => loc.isDefault);
            if (defaultIndex != -1) {
              _selectedIndex = defaultIndex;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "No Current Locations!",
                style: AppTextStyles.paragraph02Regular.copyWith(
                  color: const Color(0xFF0D0F11),
                ),
              ),
              SizedBox(height: 8.h),
              Column(
                children: List.generate(locations.length, (index) {
                  final item = locations[index];
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary05.withAlpha(20)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary05
                              : const Color(0xFFB3B3B3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: AppColors.primary05,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.label,
                                  style: AppTextStyles.paragraph02SemiBold
                                      .copyWith(
                                    color: isSelected
                                        ? AppColors.primary05
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  item.address,
                                  style: AppTextStyles.captionRegular.copyWith(
                                    color: const Color(0xFF78808B),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
