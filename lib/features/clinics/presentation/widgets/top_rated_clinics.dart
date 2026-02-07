import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_state.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedClinics extends StatelessWidget {
  final CategoryEntity? selectedCategory;
  final String? searchQuery;
  final List<String>? filterCategories;
  final List<int>? filterRatings;

  const TopRatedClinics({
    super.key,
    this.selectedCategory,
    this.searchQuery,
    this.filterCategories,
    this.filterRatings,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicsCubit, ClinicsState>(
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
              child: Text("Couldn't fetch clinics!\nPull to refresh"),
            ),
          );
        }

        if (state is GetClinicsSuccessfully) {
          List<ClinicEntity> clinics = state.clinics;

          if (selectedCategory != null) {
            clinics = clinics
                .where(
                  (clinic) => clinic.clinicCategories.any(
                    (cat) => cat.code == selectedCategory!.code,
                  ),
                )
                .toList();
          }

          if (filterCategories != null && filterCategories!.isNotEmpty) {
            clinics = clinics
                .where(
                  (clinic) => clinic.clinicCategories.any(
                    (cat) => filterCategories!.contains(cat.code),
                  ),
                )
                .toList();
          }

          if (filterRatings != null && filterRatings!.isNotEmpty) {
            clinics = clinics
                .where(
                  (clinic) =>
                      filterRatings!.contains(clinic.clinicAverageRating),
                )
                .toList();
          }

          if (searchQuery != null && searchQuery!.isNotEmpty) {
            clinics = clinics
                .where(
                  (clinic) => clinic.clinicName.toLowerCase().contains(
                        searchQuery!.toLowerCase(),
                      ),
                )
                .toList();
          }

          if (clinics.isEmpty) {
            return const SizedBox(
              height: 130,
              child: Center(child: Text("No clinics found.")),
            );
          }

          return SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: clinics.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final clinic = clinics[index];
                return _clinicCard(context, clinic);
              },
            ),
          );
        }

        return const SizedBox(height: 130);
      },
    );
  }

  Widget _clinicCard(BuildContext context, ClinicEntity clinic) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClinicDetailsPage(clinic: clinic),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
              child: clinic.clinicLogoUrl.isNotEmpty
                  ? Image.network(
                      clinic.clinicLogoUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 100,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 7.5),
                    decoration: BoxDecoration(
                      color: AppColors.secondary01,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.secondary04,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "${clinic.clinicAverageRating} ( ${clinic.clinicRatingCount} Reviews )",
                          style: AppTextStyles.footerRegular,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    clinic.clinicName,
                    style: AppTextStyles.paragraph01SemiBold.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    clinic.clinicDescription,
                    style: AppTextStyles.captionRegular.copyWith(
                      color: const Color(0xFF393E46),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                      Expanded(
                        child: Text(
                          clinic.clinicLocation,
                          style: AppTextStyles.captionRegular.copyWith(
                            color: const Color(0xFF78808B),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
