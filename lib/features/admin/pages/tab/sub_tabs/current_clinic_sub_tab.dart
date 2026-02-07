import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_state.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';

class CurrentClinicSubTab extends StatelessWidget {
  const CurrentClinicSubTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicsCubit, ClinicsState>(
      builder: (context, state) {
        if (state is GetClinicsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetClinicsFailed) {
          return Center(
            child: Text(
              "Failed to load clinics\n${state.errMessage}",
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is GetClinicsSuccessfully) {
          final currentClinics = state.clinics
              .where((clinic) => clinic.clinicStatus == "APPROVED")
              .toList();

          if (currentClinics.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<ClinicsCubit>().getAllClinics(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(child: Text("There are no clinics currently.")),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<ClinicsCubit>().getAllClinics(),
            child: ListView.separated(
              itemCount: currentClinics.length,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 16.h),
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final clinic = currentClinics[index];

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
                    child: Row(
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
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                clinic.clinicName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.paragraph01SemiBold,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                clinic.clinicDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                    clinic.clinicLocation,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        AppTextStyles.captionRegular.copyWith(
                                      color: const Color(0xFF78808B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () async {
                                  final clinicsCubit =
                                      context.read<ClinicsCubit>();

                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Confirm Reject"),
                                      content: const Text(
                                        "Are you sure you want to reject this clinic?\nThis action can't be undone!",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            "Reject",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    final params =
                                        AdminApproveRejectClinicParams(
                                      clinicID: clinic.clinicId,
                                      actionStatus: "REJECTED",
                                    );
                                    await clinicsCubit
                                        .adminApproveRejectClinic(params);
                                  }
                                },
                                child: const Text(
                                  "Delete Clinic",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
