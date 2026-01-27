import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/password/presentation/cubit/password_cubit.dart';
import 'package:glowguide/features/password/presentation/cubit/password_states.dart';
import 'package:glowguide/features/auth/presentation/widgets/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/features/password/presentation/pages/new_password_page.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = "";

  void submit() {
    if (otp.length != 6) {
      CustomScaffoldMessenger().showFail("Please enter the 6-digit code.");
      return;
    }

    context.read<PasswordCubit>().confirmResetPassword(
          ConfirmResetPasswordParams(
            email: widget.email,
            otp: otp,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordCubit, PasswordStates>(
      listener: (context, state) {
        if (state is ConfirmResetPasswordFailed) {
          CustomScaffoldMessenger().showFail(state.errMessage);
        }

        if (state is ConfirmResetPasswordSuccessfully) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewPasswordPage(tempToken: state.tempToken)),
              (routes) => false);
        }
      },
      builder: (context, state) {
        final isLoading = state is ConfirmResetPasswordLoading;

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 85.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Verify Your Email",
                    style: AppTextStyles.heading01SemiBold),
                SizedBox(height: 40.h),
                const Text("OTP Code", style: AppTextStyles.paragraph02Regular),
                SizedBox(height: 8.h),
                OtpForm(
                  onChanged: (value) {
                    setState(() => otp = value);
                  },
                ),
                SizedBox(height: 40.h),
                ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white)
                      : const Text("Confirm"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
