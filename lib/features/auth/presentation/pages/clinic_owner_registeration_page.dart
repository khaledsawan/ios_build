import 'dart:io';
import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/utils/validators.dart';
import 'package:glowguide/core/widgets/add_image_widget.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/custom_scaffold.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glowguide/features/auth/presentation/cubit/auth_states.dart';
import 'package:glowguide/features/auth/presentation/pages/sign_in_page.dart';
import 'package:glowguide/features/auth/presentation/widgets/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ClinicOwnerRegistrationPage extends StatefulWidget {
  const ClinicOwnerRegistrationPage({super.key});

  @override
  State<ClinicOwnerRegistrationPage> createState() =>
      _ClinicOwnerRegistrationPageState();
}

class _ClinicOwnerRegistrationPageState
    extends State<ClinicOwnerRegistrationPage> {
  final _businessController = TextEditingController();
  final _ownerController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _profileImage;
  File? _commercialImage;
  final ImagePicker _picker = ImagePicker();

  bool? isMale; // ⬅️ إضافة اختيار الجنس

  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _pickCommercialImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _commercialImage = File(pickedFile.path));
    }
  }

  void _submit() {
    if (_ownerController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Owner name is required.");
      return;
    }

    if (!Validators.isValidEmail(_emailController.text.trim())) {
      CustomScaffoldMessenger().showFail("Please enter a valid email.");
      return;
    }

    if (!Validators.isValidPassword(_passwordController.text.trim())) {
      CustomScaffoldMessenger().showFail(
        "Password must be at least 6 characters.",
      );
      return;
    }

    if (!Validators.isPasswordsMatch(
      _passwordController.text.trim(),
      _confirmPasswordController.text.trim(),
    )) {
      CustomScaffoldMessenger().showFail(
        "Password and Confirm Password do not match.",
      );
      return;
    }

    if (isMale == null) {
      CustomScaffoldMessenger().showFail("Please select your gender.");
      return;
    }

    if (_profileImage == null || _commercialImage == null) {
      CustomScaffoldMessenger().showFail("Please select both images.");
      return;
    }

    final params = SignupUserParams(
      fullName: _ownerController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      businessName: _businessController.text.trim(),
      profileImageUrl: _profileImage!,
      commercialImageUrl: _commercialImage!,
      type: "CO",
      isMale: isMale!, // ⬅️ إرسال الجنس
    );

    context.read<AuthCubit>().signupUser(params);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SignupUserSuccess) {
          CustomScaffoldMessenger().showSuccess(
            "Account created successfully!\nYou can login to your account.",
            duration: const Duration(seconds: 5),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
          );
        }

        if (state is SignupUserFailed) {
          CustomScaffoldMessenger().showFail(state.errMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is SignupUserLoading;

        return CustomScaffold(
          safeTop: false,
          children: [
            const Text(
              "Welcome to glowguide  🎉",
              style: AppTextStyles.heading01SemiBold,
            ),
            Text(
              "Enter your info to create new account",
              style: AppTextStyles.paragraph02Regular.copyWith(
                color: const Color(0xFF78808B),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Image.asset(
                AppAssets.frame,
                fit: BoxFit.cover,
                width: 300.w,
              ),
            ),
            SizedBox(height: 20.h),

            CustomInputField(
              label: "Business Name",
              hint: "Enter ...",
              controller: _businessController,
            ),
            SizedBox(height: 16.h),

            CustomInputField(
              label: "Owner’s Name",
              hint: "Enter ...",
              controller: _ownerController,
            ),
            SizedBox(height: 16.h),

            CustomInputField(
              label: "Email",
              hint: "Enter ...",
              controller: _emailController,
            ),
            SizedBox(height: 16.h),

            PhoneInputField(
              label: "Phone Number",
              controller: _phoneController,
            ),

            SizedBox(height: 16.h),

            /// --------------------  GENDER SECTION  --------------------
            Text(
              "Gender",
              style: AppTextStyles.paragraph02Regular.copyWith(
                color: AppColors.gary10,
              ),
            ),
            SizedBox(height: 8.h),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMale = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color:
                            isMale == true ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Male",
                          style: TextStyle(
                            color: isMale == true ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMale = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: isMale == false
                            ? Colors.pink
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Female",
                          style: TextStyle(
                            color:
                                isMale == false ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// ---------------------------------------------------------

            SizedBox(height: 16.h),

            AddImageWidget(
              title: "Commercial Registration",
              selectedImage: _commercialImage,
              onPressed: _pickCommercialImage,
            ),
            SizedBox(height: 16.h),

            AddImageWidget(
              title: "Profile Image",
              selectedImage: _profileImage,
              onPressed: _pickProfileImage,
            ),
            SizedBox(height: 16.h),

            CustomInputField(
              label: "Password",
              hint: "••••••••••••••••••",
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 16.h),

            CustomInputField(
              label: "Confirm Password",
              hint: "••••••••••••••••••",
              controller: _confirmPasswordController,
              obscureText: true,
            ),

            SizedBox(height: 30.h),

            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: isLoading
                  ? Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: WidgetStateProperty.all(Colors.grey),
                      )
                  : Theme.of(context).elevatedButtonTheme.style,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Continue"),
            ),
          ],
        );
      },
    );
  }
}
