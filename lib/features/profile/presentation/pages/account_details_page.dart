import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/core/widgets/loading_interface.dart';
import 'package:glowguide/features/delete_account/presentation/cubit/delete_account_cubit.dart';
import 'package:glowguide/features/delete_account/presentation/pages/delete_account_page.dart';
import 'package:glowguide/features/profile/domain/entities/account_details_entity.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_cubit.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_states.dart';
import 'package:glowguide/features/profile/presentation/pages/edite_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountDetailsPage extends StatelessWidget {
  const AccountDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountDetailsCubit, AccountDetailsStates>(
      builder: (context, state) {
        if (state is GetAccountDetailsLoading) {
          return const LoadingInterface();
        }

        if (state is GetAccountDetailsFailure) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<AccountDetailsCubit>().fetchAccountDetails();
              },
              child: SingleChildScrollView(
                child: Center(
                  child: Text(
                    state.errMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error12),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is GetAccountDetailsSuccessfully) {
          final user = state.accountDetails;

          return Scaffold(
            appBar: _appBar(context),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<AccountDetailsCubit>()
                      .fetchAccountDetails();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    _userDetails(user),
                    SizedBox(height: 24.h),
                    _profileInfo(context, user),
                    SizedBox(
                      height: 64.h,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => DeleteAccountCubit(),
                                      child: const DeleteAccountPage(),
                                    )));
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete Account"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const LoadingInterface();
        }
      },
    );
  }

  Container _profileInfo(BuildContext context, AccountDetailsEntity user) {
    final userLocation = getIt<CacheHelper>().get(ApiKey.mainLocation);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D5DD), width: 0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profile Info", style: AppTextStyles.paragraph02SemiBold),
          SizedBox(height: 16.h),
          _infoOption(context, Icons.person, user.name),
          SizedBox(height: 16.h),
          _infoOption(context, Icons.mail, user.email),
          SizedBox(height: 16.h),
          _infoOption(
            context,
            Icons.phone_android,
            user.phoneNumber.isEmpty ? "Not Set" : user.phoneNumber,
          ),
          SizedBox(height: 16.h),
          _infoOption(context, Icons.male, _formatGender(user.gender)),
          SizedBox(height: 16.h),
          _infoOption(
            context,
            Icons.calendar_month_outlined,
            _formatBirthday(user.birthday),
          ),
          SizedBox(height: 16.h),
          _infoOption(
            context,
            Icons.location_pin,
            _formatBirthday(userLocation),
          ),
        ],
      ),
    );
  }

  Row _infoOption(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16.r),
        SizedBox(width: 8.w),
        Text(title, style: AppTextStyles.paragraph02Regular),
      ],
    );
  }

  String _formatGender(bool isMale) => isMale ? "Male" : "Female";

  String _formatBirthday(String? date) {
    if (date == null || date.isEmpty) return "Not set";
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return "${parts[2]}/${parts[1]}/${parts[0]}";
      }
    } catch (_) {}
    return date;
  }

  Container _userDetails(AccountDetailsEntity user) {
    final profileImage = getIt<CacheHelper>().get(ApiKey.userProfileImage);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D5DD), width: 0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: profileImage != null
                ? NetworkImage("Https://glowguide.ae$profileImage")
                : const AssetImage(AppAssets.categoryHaircut) as ImageProvider,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.paragraph01SemiBold),
                SizedBox(height: 12.h),
                Text(user.email, style: AppTextStyles.paragraph02Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text("Account Details", style: AppTextStyles.paragraph02SemiBold),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const EditeProfileDetails(),
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
                const Icon(Icons.edit, size: 18, color: Color(0xFF4064B5)),
                SizedBox(width: 8.w),
                Text(
                  "Edit",
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
