import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/auth/presentation/pages/sign_in_page.dart';
import 'package:glowguide/features/auth/presentation/pages/choose_role_page.dart';
import 'package:glowguide/features/onboarding/widgets/or_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _imageController;
  late Animation<double> _imageFade;
  late Animation<Offset> _imageSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _imageFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeIn));
    _imageSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _imageController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  FadeTransition(
                    opacity: _imageFade,
                    child: SlideTransition(
                      position: _imageSlide,
                      child: Image.asset(
                        AppAssets.signingIcon,
                        fit: BoxFit.cover,
                        height: 375.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _imageFade,
                    child: SlideTransition(
                      position: _imageSlide,
                      child: Image.asset(
                        AppAssets.banner4,
                        fit: BoxFit.cover,
                        height: 375.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Get Started 🚀",
                          style: AppTextStyles.heading01Bold,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Join the community, read & share good experiences.",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.paragraph02Regular.copyWith(
                            color: const Color(0xFF393E46),
                          ),
                        ),
                        SizedBox(height: 35.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return const SignInPage();
                                    },
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      final tween =
                                          Tween(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).chain(
                                            CurveTween(curve: Curves.easeInOut),
                                          );

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          child: const Text("Sign In"),
                        ),
                        SizedBox(height: 16.h),
                        const OrDivider(
                          color: Color(0xFFC1DACA),
                          textColor: Color(0xFF7CAC8E),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const ChooseRolePage(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      final tween =
                                          Tween(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).chain(
                                            CurveTween(curve: Curves.easeInOut),
                                          );

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8CF2C),
                          ),
                          child: const Text("Register"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
