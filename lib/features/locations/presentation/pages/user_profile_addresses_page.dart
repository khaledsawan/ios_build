import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/widgets/loading_interface.dart';
import 'package:glowguide/features/locations/domain/entities/location_entity.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_states.dart';
import 'package:glowguide/features/locations/presentation/pages/user_add_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileAddressesPage extends StatelessWidget {
  const UserProfileAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: BlocBuilder<LocationsCubit, LocationsStates>(
        builder: (context, state) {
          if (state is GetAllLocationsLoading) {
            return const Center(child: LoadingInterface());
          }

          if (state is GetAllLocationsFailed) {
            return Center(child: Text(state.errMessage));
          }

          if (state is GetAllLocationsSuccessfully) {
            final location = state.location;

            if (location.isEmpty) {
              return const Center(child: Text("No Locations Yet!"));
            }

            return SafeArea(
              child: ListView.separated(
                itemCount: location.length,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                separatorBuilder: (context, index) => SizedBox(height: 24.h),
                itemBuilder: (context, index) {
                  return _adressCard(context, location[index]);
                },
              ),
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("An Error Occured"),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<LocationsCubit>().getAllLocations();
                    },
                    child: const Text("Reload"))
              ],
            ));
          }
        },
      ),
    );
  }

  Container _adressCard(BuildContext context, LocationEntity location) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.abc, size: 16, color: Color(0xFF292D32)),
              SizedBox(width: 4.w),
              Text(
                location.label,
                style: AppTextStyles.paragraph02SemiBold.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.abc, size: 16, color: Color(0xFF888888)),
              const SizedBox(width: 4),
              Text(
                location.address,
                style: AppTextStyles.paragraph02Regular.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.abc, size: 16, color: Color(0xFF888888)),
              const SizedBox(width: 4),
              Text(
                location.phoneNumber.isEmpty
                    ? "No Phone Number"
                    : location.phoneNumber,
                style: AppTextStyles.paragraph02Regular.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  showDragHandle: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Delete Confirmation",
                              style: AppTextStyles.paragraph02SemiBold,
                            ),
                            SizedBox(height: 16.h),
                            const Text(
                              "Are you sure you want to delete this address?",
                              style: AppTextStyles.heading01SemiBold,
                            ),
                            SizedBox(height: 44.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDD0011),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          final params = DeleteLocationParams(
                                              locationId: location.locationID);

                                          context
                                              .read<LocationsCubit>()
                                              .deleteLocation(params);

                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Yes, Delete",
                                          style: AppTextStyles
                                              .paragraph02Regular
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: AppColors.primary05,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No, Keep",
                                        style: AppTextStyles.paragraph02Regular
                                            .copyWith(
                                                color: AppColors.primary05),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFFDD0011)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete,
                        color: Color(0xFFDD0011), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Delete",
                      style: AppTextStyles.paragraph02Regular
                          .copyWith(color: const Color(0xFFDD0011)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text("Adresses"),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const UserAddLocationPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  final tween = Tween(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.person_pin_circle,
                  size: 18,
                  color: Color(0xFF4064B5),
                ),
                SizedBox(width: 8.w),
                Text(
                  "Add New",
                  style: AppTextStyles.paragraph01SemiBold.copyWith(
                    color: const Color(0xFF4064B5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
