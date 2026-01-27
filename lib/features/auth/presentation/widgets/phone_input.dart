import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String label;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.hint = "Phone Number",
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.paragraph02Regular.copyWith(
            color: AppColors.gary10,
          ),
        ),
        SizedBox(height: 8.h),
        IntlPhoneField(
          controller: controller,
          decoration: InputDecoration(
            labelText: hint,
            border: const OutlineInputBorder(borderSide: BorderSide()),
          ),
          initialCountryCode: 'AE',
        ),
      ],
    );
  }
}
