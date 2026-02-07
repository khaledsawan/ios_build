import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/widgets/my_clinics_tab_list.dart';
import 'package:glowguide/features/notifications/presentation/pages/notifications_page.dart';
import 'package:glowguide/features/clinics/presentation/pages/add_new_clinic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerMyClinicsTab extends StatelessWidget {
  const OwnerMyClinicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _appBar(context),
                SizedBox(height: 18.h),
                const MyClinicsTabList(),
                SizedBox(height: 23.h),
                _addNewClinicButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlinedButton _addNewClinicButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ClinicsCubit(),
              child: const AddNewClinicPage(),
            ),
          ),
        );
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 25.r, color: AppColors.primary05),
            const SizedBox(width: 10),
            Text(
              "Add New",
              style: AppTextStyles.paragraph01Regular.copyWith(
                color: AppColors.primary05,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _appBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("My Clinics", style: AppTextStyles.heading01SemiBold),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          },
          icon: Icon(Icons.notifications_outlined, size: 32.r),
        ),
      ],
    );
  }
}
