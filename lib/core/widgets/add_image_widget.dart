import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';

class AddImageWidget extends StatefulWidget {
  const AddImageWidget({
    super.key,
    required this.title,
    this.onPressed,
    this.selectedImage,
  });

  final String title;
  final void Function()? onPressed;
  final File? selectedImage;

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  @override
  Widget build(BuildContext context) {
    final hasImage = widget.selectedImage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.paragraph02Regular.copyWith(
            color: const Color(0xFF0D0F11),
          ),
        ),
        SizedBox(height: 10.h),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [10, 5],
            strokeWidth: 1,
            radius: Radius.circular(16.r),
            color: const Color(0xFFA5AEBB),
            padding: EdgeInsets.all(24.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasImage ? Icons.check_circle : Icons.upload_file,
                size: 40.r,
                color: hasImage ? Colors.green : Colors.grey.shade400,
              ),
              SizedBox(height: 16.h),
              Text(
                hasImage ? "Done" : "Press to add an image",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: hasImage ? Colors.green : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              if (!hasImage)
                Text(
                  "csv, pdf, png, jpeg",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              SizedBox(height: 16.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.grey.shade700,
                ),
                onPressed: widget.onPressed,
                child: Text(hasImage ? "Change" : "Browse Files"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
