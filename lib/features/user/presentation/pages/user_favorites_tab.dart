import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/layouts/user_tabs_layout.dart';
import 'package:glowguide/features/clinics/data/models/clinic_model.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_state.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';
import 'package:glowguide/features/favorites/data/models/clinic_hive_model.dart';
import 'package:glowguide/features/notifications/presentation/widgets/notifications_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserFavoritesTab extends StatelessWidget {
  const UserFavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<ClinicHiveModel> favoritesBox = Hive.box<ClinicHiveModel>(
      'favoriteClinics',
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context),
            SizedBox(height: 20.h),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: favoritesBox.listenable(),
                builder: (context, Box<ClinicHiveModel> box, _) {
                  final clinics = box.values.toList();

                  if (clinics.isEmpty) {
                    return _emptyState(context);
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: clinics.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 20.h),
                    itemBuilder: (context, index) {
                      final clinic = clinics[index];

                      return Dismissible(
                        key: Key(clinic.clinicId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          box.delete(clinic.clinicId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${clinic.clinicName} removed from favorites',
                              ),
                            ),
                          );
                        },
                        child: FavoriteClinicCard(clinic: clinic),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Favorites", style: AppTextStyles.heading01SemiBold),
          NotificationsButton(),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppAssets.favoritesIcon, width: 165.w, height: 165.h),
          SizedBox(height: 16.h),
          Text(
            "There are no items in your\nfavorites list!",
            style: AppTextStyles.paragraph01Regular.copyWith(
              color: AppColors.gary06,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: 250.w,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserTabsLayout(),
                  ),
                );
              },
              child: const Text("Explore Top Rated Clinics"),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteClinicCard extends StatefulWidget {
  final ClinicHiveModel clinic;
  const FavoriteClinicCard({super.key, required this.clinic});

  @override
  State<FavoriteClinicCard> createState() => _FavoriteClinicCardState();
}

class _FavoriteClinicCardState extends State<FavoriteClinicCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.7,
      upperBound: 1.2,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    final box = Hive.box<ClinicHiveModel>('favoriteClinics');
    final isFav = box.containsKey(widget.clinic.clinicId);

    if (isFav) {
      box.delete(widget.clinic.clinicId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.clinic.clinicName} removed from favorites'),
        ),
      );
    } else {
      box.put(widget.clinic.clinicId, widget.clinic);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.clinic.clinicName} added to favorites'),
        ),
      );
    }

    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ClinicHiveModel>('favoriteClinics');
    final isFav = box.containsKey(widget.clinic.clinicId);

    return GestureDetector(
      onTap: () {
        final clinicsCubit = context.read<ClinicsCubit>();
        final allClinics = clinicsCubit.state is GetClinicsSuccessfully
            ? (clinicsCubit.state as GetClinicsSuccessfully).clinics
            : [];

        final clinicEntity = allClinics.firstWhere(
          (c) => c.clinicId == widget.clinic.clinicId,
          orElse: () => ClinicModel(
            clinicId: widget.clinic.clinicId,
            clinicName: widget.clinic.clinicName,
            clinicLogoUrl: widget.clinic.clinicLogoUrl,
            clinicDescription: widget.clinic.clinicDescription,
            clinicLocation: widget.clinic.clinicLocation,
            clinicAverageRating: widget.clinic.clinicAverageRating.toInt(),
            clinicRatingCount: widget.clinic.clinicRatingCount,
            clinicCategories: [],
            clinicEmail: widget.clinic.clinicName,
            clinicOwnerId: "",
            clinicPhoneNumber: "",
            clinicStatus: "",
            clinicWhoAreWe: "",
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClinicDetailsPage(clinic: clinicEntity),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: widget.clinic.clinicLogoUrl != ""
                  ? Image.network(
                      widget.clinic.clinicLogoUrl,
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
                          size: 50,
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.secondary01,
                          borderRadius: BorderRadius.circular(1000.r),
                        ),
                        child: Text(
                          "${widget.clinic.clinicAverageRating} ( ${widget.clinic.clinicRatingCount} Reviews )",
                          style: AppTextStyles.footerRegular,
                        ),
                      ),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: IconButton(
                          icon: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.clinic.clinicName,
                    style: AppTextStyles.paragraph01SemiBold,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.clinic.clinicDescription,
                    style: AppTextStyles.captionRegular,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 14,
                        color: AppColors.primary05,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          widget.clinic.clinicLocation,
                          style: AppTextStyles.captionRegular,
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
