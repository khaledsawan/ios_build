import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialBottons extends StatelessWidget {
  final void Function()? googleAuth;
  final void Function()? appleAuth;
  final void Function()? facebookAuth;

  const SocialBottons({
    super.key,
    required this.googleAuth,
    required this.appleAuth,
    required this.facebookAuth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          imageAsset: 'assets/images/icons/GoogleIcon.png',
          onTap: googleAuth,
        ),
        SizedBox(width: 10.w),
        _buildSocialButton(
          imageAsset: 'assets/images/icons/AppleIcon.png',
          onTap: appleAuth,
        ),
        SizedBox(width: 10.w),
        _buildSocialButton(
          imageAsset: 'assets/images/icons/FacebookIcon.png',
          onTap: facebookAuth,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String imageAsset,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFDBDDDF), width: 1),
        ),
        child: Image.asset(imageAsset, width: 24.w),
      ),
    );
  }
}
