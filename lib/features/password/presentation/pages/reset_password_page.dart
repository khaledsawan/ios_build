import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/utils/validators.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/password/presentation/pages/otp_page.dart';
import 'package:glowguide/features/password/presentation/cubit/password_cubit.dart';
import 'package:glowguide/features/password/presentation/cubit/password_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      body: BlocConsumer<PasswordCubit, PasswordStates>(
        listener: (context, state) {
          if (state is ResetPasswordFailed) {
            CustomScaffoldMessenger().showFail(state.errMessage);
          }

          if (state is ResetPasswordSuccessfully) {
            CustomScaffoldMessenger().showSuccess("Check your email!");

            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpPage(
                      email: emailController.text.trim(),
                    ),
                  ),
                );
              }
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordLoading;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 85.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Reset Your Password",
                    style: AppTextStyles.heading01SemiBold),
                SizedBox(height: 20.h),
                CustomInputField(
                  label: "E-mail",
                  hint: "Enter ...",
                  controller: emailController,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final email = emailController.text.trim();

                          if (!Validators.isNotEmpty(email)) {
                            CustomScaffoldMessenger()
                                .showFail("Email cannot be empty");
                            return;
                          }

                          if (!Validators.isValidEmail(email)) {
                            CustomScaffoldMessenger()
                                .showFail("Invalid email format");
                            return;
                          }

                          final params = ResetPasswordParams(email: email);
                          context.read<PasswordCubit>().resetPassword(params);
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white)
                      : const Text("Reset Password"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
