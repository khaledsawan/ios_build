import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/locations/presentation/pages/user_add_location_page.dart';
import 'package:glowguide/features/locations/presentation/widgets/user_current_locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showLocationBottomSheet(BuildContext context) {
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
                    "Location",
                    style: AppTextStyles.paragraph01Regular.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserAddLocationPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Add New Location",
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
              SizedBox(height: 16.h),

              const UserCurrentLocations(),

              SizedBox(height: 44.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
