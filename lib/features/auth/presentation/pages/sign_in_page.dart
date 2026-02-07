import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/databases/api/dio_consumer.dart';
import 'package:glowguide/core/layouts/auth_layout.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/google_sign_in_service.dart';
import 'package:glowguide/core/utils/validators.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glowguide/features/auth/presentation/cubit/auth_states.dart';
import 'package:glowguide/features/auth/presentation/pages/choose_role_page.dart';
import 'package:glowguide/features/password/presentation/pages/reset_password_page.dart';
import 'package:glowguide/features/auth/presentation/widgets/social_bottons.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Email/password login
  void submitEmailLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!Validators.isValidEmail(email)) {
      CustomScaffoldMessenger().showFail("Please enter a valid email.");
      return;
    }

    if (!Validators.isValidPassword(password)) {
      CustomScaffoldMessenger().showFail(
        "Password must be at least 6 characters.",
      );
      return;
    }

    final params = LoginParams(email: email, password: password);

    context.read<AuthCubit>().loginUserWithEmailAndPassword(params);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginUserSuccessfully) {
          CustomScaffoldMessenger().showSuccess("Logged In Successfully!");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthLayout()),
            (route) => false,
          );
        }

        if (state is LoginUserFailed) {
          CustomScaffoldMessenger().showFail(state.errMessage);
        }
      },
      builder: (context, state) {
        final isEmailLoading = state is LoginUserLoading;

        final googleService = GoogleSignInService();
        final api = DioConsumer(dio: Dio());
        final repo = GoogleAuthRepository(GoogleAuthRemoteDataSource(api));

        Future<Map<String, dynamic>?> signInWithGoogle() async {
          // 1️⃣ Sign out previous session
          await googleService.signOut();

          // 2️⃣ Start a new Google sign-in
          final idToken = await googleService.signInAndGetIdToken();

          if (idToken == null) {
            // print('Google sign-in cancelled');
            return null;
          }

          // 3️⃣ Login to backend
          final result = await repo.loginWithGoogle(idToken);
          // print('Google login done: ${result['user']}');
          return result;
        }

        return PopScope(
          canPop: false,
          child: Scaffold(
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _headerImage(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello ! 👋🏻",
                            style: AppTextStyles.heading01SemiBold,
                          ),
                          const Text(
                            "Enter your account details to log in.",
                            style: AppTextStyles.paragraph02Regular,
                          ),
                          SizedBox(height: 32.h),
                          CustomInputField(
                            label: "E-mail",
                            hint: "Enter ...",
                            controller: emailController,
                          ),
                          SizedBox(height: 16.h),
                          CustomInputField(
                            label: "Password",
                            hint: "••••••••••••••••••",
                            controller: passwordController,
                            obscureText: true,
                          ),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                    pageBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                    ) =>
                                        const ResetPasswordPage(),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      final tween = Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).chain(
                                        CurveTween(
                                          curve: Curves.easeInOut,
                                        ),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                "Forget Password?",
                                style: AppTextStyles.paragraph02SemiBold
                                    .copyWith(color: const Color(0xFF393E46)),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          ElevatedButton(
                            onPressed: isEmailLoading ? null : submitEmailLogin,
                            style: isEmailLoading
                                ? Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .copyWith(
                                      backgroundColor: WidgetStateProperty.all(
                                        Colors.grey,
                                      ),
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 20,
                                        ),
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                : Theme.of(context).elevatedButtonTheme.style,
                            child: isEmailLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Login"),
                          ),
                          SizedBox(height: 15.h),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "OR CONTINUE WITH",
                              style: AppTextStyles.captionSemiBold.copyWith(
                                color: const Color(0xFF78808B),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          SocialBottons(
                            googleAuth: () async {
                              try {
                                final result = await signInWithGoogle();

                                if (result != null && context.mounted) {
                                  await Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthLayout()),
                                    (route) => false,
                                  );
                                }
                              } finally {}
                            },
                            appleAuth: () {},
                            facebookAuth: () {},
                          ),
                          SizedBox(height: 15.h),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChooseRolePage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Don’t have an account? Create account",
                                style: AppTextStyles.paragraph02SemiBold
                                    .copyWith(color: const Color(0xFF94807C)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Stack _headerImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          AppAssets.loginBanner,
          fit: BoxFit.fill,
          height: 200.h,
          width: double.infinity,
        ),
        Image.asset(AppAssets.logo, fit: BoxFit.contain, height: 100.h),
      ],
    );
  }
}
