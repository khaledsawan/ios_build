import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_state.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';
import 'package:glowguide/features/clinics/presentation/pages/edit_clinic_page.dart';
import 'package:glowguide/features/locations/presentation/pages/contact_us_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyClinicsTabList extends StatelessWidget {
  const MyClinicsTabList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicsCubit, ClinicsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ClinicsCubit>().getAllClinics();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: _buildContent(context, state),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ClinicsState state) {
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
            "Couldn't fetch clinics!\nPull to refresh",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state is GetClinicsSuccessfully) {
      final clinics = state.clinics;

      if (clinics.isEmpty) {
        return const SizedBox(
          height: 130,
          child: Center(child: Text("You don't have any clinics yet!")),
        );
      }

      return Column(
        children: List.generate(
          clinics.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _clinicCard(context, clinics[index]),
          ),
        ),
      );
    }

    return const SizedBox(
      height: 130,
      child: Center(child: Text("An unexpected error occurred")),
    );
  }

  GestureDetector _clinicCard(BuildContext context, ClinicEntity clinic) {
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFCE8),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "${clinic.clinicAverageRating.toString()} ( ${clinic.clinicRatingCount} Reviews )",
                          style: AppTextStyles.footerRegular,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    clinic.clinicName,
                    style: AppTextStyles.paragraph01SemiBold.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    clinic.clinicDescription,
                    style: AppTextStyles.captionRegular.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.primary05,
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
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditClinicPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFF4064B5),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Color(0xFF4064B5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      showDragHandle: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 24.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Delete Confirmation",
                                  style: AppTextStyles.paragraph01SemiBold,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "Are you sure you want to delete ${clinic.clinicName}?\n Only admins cant delete clinics go to contact us and ask admins to delete your clinic",
                                  style: AppTextStyles.paragraph01Regular,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 24.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ContactUsPage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDD0011),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Contact us page",
                                              style: AppTextStyles
                                                  .paragraph02Regular
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.primary05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "No, Keep",
                                              style: AppTextStyles
                                                  .paragraph02Regular
                                                  .copyWith(
                                                color: AppColors.primary05,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFDD0011),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete,
                        size: 16,
                        color: Color(0xFFDD0011),
                      ),
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
}
