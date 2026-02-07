import 'package:flutter/material.dart';
import 'package:glowguide/core/constants/app_assets.dart';

class CustomScaffold extends StatelessWidget {
  final void Function()? onTap;
  final bool safeTop;
  final bool safeBottom;
  final bool showBackButton;
  final List<Widget> children;

  const CustomScaffold({
    super.key,
    this.onTap,
    this.safeTop = true,
    this.safeBottom = true,
    this.showBackButton = true,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: safeTop,
        bottom: safeBottom,
        child: GestureDetector(
          onTap: onTap,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset(
                  AppAssets.ellipse,
                  width: 225,
                  height: 120,
                  fit: BoxFit.fill,
                ),

                Positioned.fill(
                  child: Container(color: Colors.white.withAlpha(235)),
                ),

                if (showBackButton)
                  Positioned(
                    top: 44,
                    left: 16,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, size: 24),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 85,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...children, const SizedBox(height: 10)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
