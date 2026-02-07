import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/auth/presentation/widgets/logout_button.dart';
import 'package:glowguide/features/password/presentation/cubit/password_cubit.dart';
import 'package:glowguide/features/password/presentation/cubit/password_states.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_cubit.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_states.dart';
import 'package:glowguide/features/profile/presentation/pages/account_details_page.dart';
import 'package:glowguide/features/locations/presentation/pages/contact_us_page.dart';
import 'package:glowguide/features/locations/presentation/pages/faq_page.dart';
import 'package:glowguide/features/locations/presentation/pages/user_profile_addresses_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfileTab extends StatefulWidget {
  const MyProfileTab({super.key});

  @override
  State<MyProfileTab> createState() => _MyProfileTabState();
}

class _MyProfileTabState extends State<MyProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Column(
            children: [
              _appBar(context),
              SizedBox(height: 16.h),
              _welcomingText(),
              SizedBox(height: 16.h),
              _reviewsStatus(),
              SizedBox(height: 24.h),
              _accountSection(context),
              SizedBox(height: 24.h),
              _usefulLinksSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Column _usefulLinksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Useful Links",
          style: AppTextStyles.paragraph02SemiBold.copyWith(
            color: const Color(0xFF78808B),
          ),
        ),
        _profileOption(context, Icons.chat_bubble_outline_rounded, "FAQ", () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const FaqPage(),
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
        }),
        _profileOption(context, Icons.send, "Contact Us", () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ContactUsPage(),
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
        }),
      ],
    );
  }

  Column _accountSection(BuildContext context) {
    final userType = getIt<CacheHelper>().get(ApiKey.type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account",
          style: AppTextStyles.paragraph02SemiBold.copyWith(
            color: const Color(0xFF78808B),
          ),
        ),
        _profileOption(context, Icons.person_outline, "Account Details", () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AccountDetailsPage(),
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
        }),
        _profileOption(context, Icons.shield_outlined, "Change Password", () {
          _changePassword(context);
        }),
        userType == "CO"
            ? const SizedBox()
            : _profileOption(context, Icons.map_outlined, "Addresses", () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const UserProfileAddressesPage(),
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
              }),
        _profileOption(context, Icons.language, "Language", () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            showDragHandle: true,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              String selectedLanguage = "en";

              return StatefulBuilder(
                builder: (context, setState) {
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Change Language",
                                style: AppTextStyles.paragraph01SemiBold,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: AppTextStyles.paragraph02SemiBold
                                      .copyWith(
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
                          _languageCard(
                            title: "English (USA)",
                            flag: "🇺🇸",
                            isSelected: selectedLanguage == "en",
                            onTap: () =>
                                setState(() => selectedLanguage = "en"),
                          ),
                          SizedBox(height: 44.h),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Confirm"),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ],
    );
  }

  Widget _languageCard({
    required String title,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary05.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary05),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary05,
              size: 24.r,
            ),
            SizedBox(width: 16.w),
            Text("$flag  $title", style: AppTextStyles.paragraph01SemiBold),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _changePassword(BuildContext context) {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    String errorMessage = "";

    return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocConsumer<PasswordCubit, PasswordStates>(
              listener: (context, state) {
                if (state is SetNewPasswordByPasswordFailed) {
                  setState(() {
                    errorMessage = state.errMessage; // ← تحديث الرسالة
                  });
                }

                if (state is SetNewPasswordByPasswordSuccessfully) {
                  Navigator.pop(context);
                  CustomScaffoldMessenger()
                      .showSuccess("Password was changed successfully");
                }
              },
              builder: (context, state) {
                final isLoading = state is SetNewPasswordByPasswordLoading;

                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Change Password",
                                style: AppTextStyles.paragraph01SemiBold),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style:
                                    AppTextStyles.paragraph02SemiBold.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.primary05,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        CustomInputField(
                          label: "Old Password",
                          hint: "••••••••••••••••••",
                          controller: oldController,
                        ),
                        SizedBox(height: 16.h),
                        CustomInputField(
                          label: "New Password",
                          hint: "••••••••••••••••••",
                          controller: newController,
                        ),
                        SizedBox(height: 16.h),
                        CustomInputField(
                          label: "Confirm New Password",
                          hint: "••••••••••••••••••",
                          controller: confirmController,
                        ),
                        if (errorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                        SizedBox(height: 30.h),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (newController.text !=
                                      confirmController.text) {
                                    setState(() {
                                      errorMessage =
                                          "Passwords do not match"; // ← عرض خطأ هنا
                                    });
                                    return;
                                  }

                                  context
                                      .read<PasswordCubit>()
                                      .setNewPasswordByPassword(
                                        ResetPasswordByPasswordParams(
                                          oldPassword: oldController.text,
                                          newPassword: newController.text,
                                        ),
                                      );
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white)
                              : const Text("Confirm"),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  ListTile _profileOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F9F6),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 20.r, color: const Color(0xFF7CAC8E)),
      ),
      title: Text(title, style: AppTextStyles.paragraph02SemiBold),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.w, color: Colors.black),
      onTap: onTap,
    );
  }

  Widget _reviewsStatus() {
    return BlocBuilder<AccountDetailsCubit, AccountDetailsStates>(
      builder: (context, state) {
        if (state is GetAccountDetailsFailure) {
          return Center(child: Text(state.errMessage));
        }

        if (state is GetAccountDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetAccountDetailsSuccessfully) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F1EA),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8.w),
                          Text(
                            state.accountDetails.approvedReviews.toString(),
                            style: AppTextStyles.paragraph02SemiBold,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      const Text(
                        "Published Reviews",
                        style: AppTextStyles.paragraph02Regular,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF8C4),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel, color: Colors.red),
                          SizedBox(width: 8.w),
                          Text(
                            state.accountDetails.rejectedReviews.toString(),
                            style: AppTextStyles.paragraph02SemiBold,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      const Text(
                        "Refused Reviews",
                        style: AppTextStyles.paragraph02Regular,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text("An error occured"));
        }
      },
    );
  }

  Row _welcomingText() {
    final userFullName = getIt<CacheHelper>().get(ApiKey.userFullName);
    final profileImage = getIt<CacheHelper>().get(ApiKey.userProfileImage);

    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundImage: profileImage != null
              ? NetworkImage("Https://glowguide.ae$profileImage")
              : const AssetImage(AppAssets.categoryHaircut) as ImageProvider,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $userFullName 👋🏻",
                style: AppTextStyles.paragraph01SemiBold,
              ),
              const Text(
                "Take a look on your activity & history",
                style: AppTextStyles.paragraph02Regular,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _appBar(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("My Profile", style: AppTextStyles.heading01SemiBold),
        SignOutButton(),
      ],
    );
  }
}
