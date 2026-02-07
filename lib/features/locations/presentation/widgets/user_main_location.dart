import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/locations/data/models/locations_model.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_states.dart';
import 'package:glowguide/features/locations/presentation/widgets/user_location_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserMainLocation extends StatelessWidget {
  const UserMainLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsCubit, LocationsStates>(
      builder: (context, state) {
        if (state is GetAllLocationsFailed) {
          return _buildUI(context, state.errMessage);
        }
        if (state is GetAllLocationsLoading) {
          return _buildUI(context, "Loading..");
        }
        if (state is GetAllLocationsSuccessfully) {
          final locations = state.location;

          if (locations.isEmpty) {
            return _buildUI(context, "No Locations Yet!");
          }

          final defaultLocation = locations.firstWhere(
            (loc) => loc.isDefault == true,
            orElse: () => LocationsModel(
              locationID: "",
              userID: "",
              label: "No default location found",
              floor: "",
              address: "",
              flat: "",
              isDefault: false,
              phoneNumber: "",
            ),
          );

          return _buildUI(context, defaultLocation.address);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Padding _buildUI(BuildContext context, String location) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.location_on, size: 25.r, color: AppColors.primary05),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              location,
              maxLines: 1,
              style: AppTextStyles.paragraph02Regular,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () {
              showLocationBottomSheet(context);
            },
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 25.r,
              color: AppColors.primary05,
            ),
          ),
        ],
      ),
    );
  }
}
