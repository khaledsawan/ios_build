import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:glowguide/core/layouts/auth_layout.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    await CacheHelper().removeData(key: ApiKey.access);
    await CacheHelper().removeData(key: ApiKey.refresh);
    await CacheHelper().removeData(key: ApiKey.userID);
    await CacheHelper().removeData(key: ApiKey.type);

    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthLayout()));
    }
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: AppColors.error08),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (context.mounted) {
        _logout(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _showLogoutConfirmation(context);
      },
      icon: const Icon(Icons.logout, color: Colors.red),
    );
  }
}
