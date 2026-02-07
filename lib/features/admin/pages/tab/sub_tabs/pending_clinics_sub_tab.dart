import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_state.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';

class PendingClinicsSubTab extends StatelessWidget {
  const PendingClinicsSubTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicsCubit, ClinicsState>(
      builder: (context, state) {
        if (state is GetClinicsLoading) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is GetClinicsFailed) {
          return Center(
            child: Text(
              "Failed to load reviews\n${state.errMessage}",
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is GetClinicsSuccessfully) {
          final pendingClinics = state.clinics
              .where((review) => review.clinicStatus == "PENDING")
              .toList();

          if (pendingClinics.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ClinicsCubit>().getAllClinics();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(child: Text("There is no pending clinics currently.")),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ClinicsCubit>().getAllClinics();
            },
            child: ListView.separated(
              itemCount: pendingClinics.length,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 16.h),
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final clinic = pendingClinics[index];

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
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: clinic.clinicLogoUrl.isNotEmpty
                                  ? Image.network(
                                      clinic.clinicLogoUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.broken_image,
                                      size: 100,
                                      color: Colors.grey[400],
                                    ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          size: 22,
                                          color: Color(0xFFFFC107),
                                        ),
                                        const SizedBox(width: 2.5),
                                        Text(
                                          "${clinic.clinicAverageRating} ( ${clinic.clinicRatingCount} )",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.footerRegular
                                              .copyWith(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    clinic.clinicName,
                                    style: AppTextStyles.paragraph01SemiBold,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    clinic.clinicDescription,
                                    style: AppTextStyles.captionRegular,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Color(0xFF7CAC8E),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        clinic.clinicLocation,
                                        style: AppTextStyles.captionRegular
                                            .copyWith(
                                          color: const Color(0xFF78808B),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final params = AdminApproveRejectClinicParams(
                                    clinicID: clinic.clinicId,
                                    actionStatus: "APPROVED",
                                  );

                                  context
                                      .read<ClinicsCubit>()
                                      .adminApproveRejectClinic(params);

                                  context.read<ClinicsCubit>().getAllClinics();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success12,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Approve",
                                      style: AppTextStyles.paragraph02Regular
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final params = AdminApproveRejectClinicParams(
                                    clinicID: clinic.clinicId,
                                    actionStatus: "REJECTED",
                                  );

                                  context
                                      .read<ClinicsCubit>()
                                      .adminApproveRejectClinic(params);

                                  context.read<ClinicsCubit>().getAllClinics();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.error12,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
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
                );
              },
            ),
          );
        }
        return Center(
          child: Column(
            children: [
              const Text(
                "An error occurred",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.error12),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<ClinicsCubit>().getAllClinics();
                },
                child: const Text("Rerty"),
              ),
            ],
          ),
        );
      },
    );
  }
}
