import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/auth/presentation/pages/user_registeration_page.dart';
import 'package:glowguide/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glowguide/features/auth/presentation/pages/clinic_owner_registeration_page.dart';
import 'package:glowguide/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  bool checkBox = false;
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
        child: Column(
          children: [
            const Text("Welcome to GlowGuide  🎉",
                style: AppTextStyles.heading01SemiBold),
            const Text(
              "Enter your info to create new account",
              style: AppTextStyles.paragraph02Regular,
            ),
            SizedBox(height: 12.h),
            Center(
              child:
                  Image.asset(AppAssets.frame, fit: BoxFit.cover, width: 300.w),
            ),
            SizedBox(height: 18.h),
            Text(
              "Who are you ?",
              style: AppTextStyles.paragraph02Regular.copyWith(
                color: const Color(0xFF0D0F11),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _chooseRole(
                  title: "User",
                  icon: Icons.person_outlined,
                  isSelected: selectedRole == "User",
                  onTap: () {
                    setState(() {
                      selectedRole = "User";
                    });
                  },
                ),
                SizedBox(width: 12.w),
                _chooseRole(
                  title: "Clinic Owner",
                  icon: Icons.store,
                  isSelected: selectedRole == "Owner",
                  onTap: () {
                    setState(() {
                      selectedRole = "Owner";
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: checkBox,
                  onChanged: (value) {
                    setState(() {
                      checkBox = value ?? false;
                    });
                  },
                ),
                // Wrap Text in Flexible instead of Expanded
                Flexible(
                  child: GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(
                          'https://eng-hasantf.github.io/GlowGuidePrivacyAndPolicy/privacy.html');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        debugPrint('Could not launch $url');
                      }
                    },
                    child: const Text(
                      "By ticking, you are confirming, and agree to our Privacy Policy & Terms and Conditions.",
                      style: AppTextStyles.paragraph02SemiBold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            BlocProvider(
              create: (context) => AuthCubit(),
              child: ElevatedButton(
                onPressed: () {
                  if (!checkBox) {
                    CustomScaffoldMessenger().showFail(
                        "You must agree to Policies and Privacy first");
                    return;
                  }

                  if (selectedRole == "User") {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const UserRegisterationPage(),
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
                  } else if (selectedRole == "Owner") {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ClinicOwnerRegistrationPage(),
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
                  } else {
                    CustomScaffoldMessenger()
                        .showFail("Please select a role first");
                  }
                },
                child: const Text("Continue"),
              ),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                "OR CONTINUE WITH",
                style: AppTextStyles.captionSemiBold.copyWith(
                  color: const Color(0xFF78808B),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: Text(
                  "Already have an account?  Sign In",
                  style: AppTextStyles.paragraph02SemiBold.copyWith(
                    color: const Color(0xFF94807C),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _chooseRole({
    required IconData icon,
    required String title,
    required bool isSelected,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 135.w,
        height: 135.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x187CAC8F) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF7CAC8E) : const Color(0xFFDBDDDF),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.r,
              color: isSelected
                  ? const Color(0xFF7CAC8E)
                  : const Color(0xFFA5AEBB),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyles.paragraph02Regular.copyWith(
                color: isSelected
                    ? const Color(0xFF7CAC8E)
                    : const Color(0xFFA5AEBB),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
