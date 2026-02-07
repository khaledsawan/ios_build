import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/layouts/auth_layout.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/features/delete_account/presentation/cubit/delete_account_cubit.dart';
import 'package:glowguide/features/delete_account/presentation/cubit/delete_account_state.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _deleteAccount() async {
    if (_formKey.currentState!.validate()) {
      final params = DeleteAccountParams(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await context.read<DeleteAccountCubit>().deleteAccount(params);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Account Deleted"),
              content:
                  const Text("Your account has been successfully deleted."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );

          getIt<CacheHelper>().clear();

          if (mounted) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const AuthLayout()));
          }
        } else if (state is DeleteAccountFailed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Deletion Failed"),
              content: Text(state.errMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteAccountLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Delete Account'),
            backgroundColor: Colors.red,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ⚠ Warning Text
                    const Text(
                      "⚠ Warning: Deleting your account is irreversible! "
                      "All your data will be permanently removed.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    CustomInputField(
                      label: "Email",
                      hint: "Enter your email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomInputField(
                      label: "Password",
                      hint: "Enter your password",
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomInputField(
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm your password";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            onPressed: _deleteAccount,
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
          ),
        );
      },
    );
  }
}
