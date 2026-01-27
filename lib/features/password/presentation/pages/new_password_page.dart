import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/layouts/auth_layout.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/password/presentation/cubit/password_cubit.dart';
import 'package:glowguide/features/password/presentation/cubit/password_states.dart';
import 'package:glowguide/core/params/params.dart';

class NewPasswordPage extends StatefulWidget {
  final String tempToken;

  const NewPasswordPage({super.key, required this.tempToken});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  void submit() {
    final pass = newPassController.text.trim();
    final confirm = confirmPassController.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      CustomScaffoldMessenger().showFail("All fields are required.");
      return;
    }

    if (pass.length < 6) {
      CustomScaffoldMessenger()
          .showFail("Password must be at least 6 characters.");
      return;
    }

    if (pass != confirm) {
      CustomScaffoldMessenger().showFail("Passwords do not match.");
      return;
    }

    context.read<PasswordCubit>().setNewPassword(
        NewPasswordParams(newPassword: pass, token: widget.tempToken));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordCubit, PasswordStates>(
      listener: (context, state) {
        if (state is SetNewPasswordFailed) {
          CustomScaffoldMessenger().showFail(state.errMessage);
        }

        if (state is SetNewPasswordSuccessfully) {
          CustomScaffoldMessenger()
              .showSuccess("Password updated successfully!");

          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AuthLayout(),
                  ),
                  (routes) => false);
            }
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is SetNewPasswordLoading;

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 85.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create New Password",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 40.h),
                CustomInputField(
                    label: "New Password",
                    hint: "**********",
                    obscureText: true,
                    controller: newPassController),
                SizedBox(height: 20.h),
                CustomInputField(
                    label: "New Password",
                    hint: "**********",
                    obscureText: true,
                    controller: confirmPassController),
                SizedBox(height: 50.h),
                ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
