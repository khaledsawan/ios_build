import 'package:flutter/material.dart';
import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';

class LoadingInterface extends StatelessWidget {
  const LoadingInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.logo,
            height: 250,
            width: 250,
          ),
          const SizedBox(height: 50),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
