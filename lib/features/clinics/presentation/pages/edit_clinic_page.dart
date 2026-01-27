import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/add_image_widget.dart';
import 'package:glowguide/features/user/presentation/widgets/user_search_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditClinicPage extends StatelessWidget {
  const EditClinicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              _inputFields(),
              SizedBox(height: 16.h),
              AddImageWidget(title: "Clinic Logo", onPressed: () {}),
              SizedBox(height: 16.h),
              AddImageWidget(
                title: "Commercial Registration",
                onPressed: () {},
              ),
              SizedBox(height: 16.h),
              const Categories(),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Save Changes"),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Column _inputFields() {
    final controller = TextEditingController();

    return Column(
      children: [
        CustomInputField(
          label: "Clinic Name",
          hint: "Enter ...",
          controller: controller,
        ),
        SizedBox(height: 16.h),
        CustomInputField(
          label: "Clinic Description",
          hint: "Enter ...",
          controller: controller,
        ),
        SizedBox(height: 16.h),
        CustomInputField(
          label: "Clinic Location",
          hint: "Enter ...",
          controller: controller,
        ),
        SizedBox(height: 16.h),
        CustomInputField(
          label: "Clinic Phone Number",
          hint: "Enter ...",
          controller: controller,
        ),
        SizedBox(height: 16.h),
        CustomInputField(
          label: "Clinic Email",
          hint: "Enter ...",
          controller: controller,
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text("Edit Clinic", style: AppTextStyles.paragraph02SemiBold),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  size: 24,
                  color: Color(0xFFDD0011),
                ),
                SizedBox(width: 4.w),
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
