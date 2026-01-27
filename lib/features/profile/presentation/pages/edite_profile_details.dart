import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_states.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_cubit.dart';

class EditeProfileDetails extends StatefulWidget {
  const EditeProfileDetails({super.key});

  @override
  State<EditeProfileDetails> createState() => _EditeProfileDetailsState();
}

class _EditeProfileDetailsState extends State<EditeProfileDetails> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountDetailsCubit, AccountDetailsStates>(
        listener: (context, state) {
      if (state is UpdateProfileSuccessfully) {
        CustomScaffoldMessenger()
            .showSuccess("Profile details updated successfully!");

        context.read<AccountDetailsCubit>().fetchAccountDetails();
      }

      if (state is UpdateProfileFailed) {
        CustomScaffoldMessenger().showFail(state.errMessage);
      }
    }, builder: (context, state) {
      final isLoading = state is UpdateProfileLoading;

      return Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _profilePicture(),
                SizedBox(height: 24.h),
                _profileInfo(),
                SizedBox(height: 40.h),
                isLoading
                    ? ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: const CircularProgressIndicator(),
                      )
                    : _saveButton(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Column _profileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile Info", style: AppTextStyles.paragraph01SemiBold),
        SizedBox(height: 16.h),
        CustomInputField(
          label: "Username",
          hint: "Hasan Tafankaji",
          controller: _usernameController,
        ),
        SizedBox(height: 16.h),
        CustomInputField(
          label: "Phone Number",
          hint: "+963 981 544 999",
          controller: _phoneController,
        ),
        SizedBox(height: 16.h),
        GestureDetector(
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000, 1, 1),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (selectedDate != null) {
                _birthdayController.text =
                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                setState(() {});
              }
            },
            child: AbsorbPointer(
              child: CustomInputField(
                label: "Birthday",
                hint: "YYYY-MM-DD",
                controller: _birthdayController,
              ),
            ))
      ],
    );
  }

  Widget _profilePicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile Picture", style: AppTextStyles.paragraph01SemiBold),
        SizedBox(height: 16.h),
        Center(
          child: GestureDetector(
            onTap: _pickProfileImage,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF707070),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: _profileImage == null
                  ? Icon(Icons.camera_alt_outlined,
                      size: 40.r, color: Colors.white)
                  : ClipOval(
                      child: Image.file(
                        _profileImage!,
                        width: 100.w,
                        height: 100.w,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final params = UpdateProfileParams(
            fullName: _usernameController.text.trim().isEmpty
                ? null
                : _usernameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            birthday: _birthdayController.text.trim().isEmpty
                ? null
                : _birthdayController.text.trim(),
            isMale: null,
            profileImage: _profileImage,
          );

          context.read<AccountDetailsCubit>().updateProfile(params: params);
        },
        child: const Text("Save Changes"),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text("Edit Details", style: AppTextStyles.paragraph02SemiBold),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                const Icon(Icons.close, size: 24, color: Color(0xFFDD0011)),
                Text(
                  "Cancel",
                  style: AppTextStyles.paragraph01SemiBold.copyWith(
                    color: const Color(0xFFDD0011),
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
