import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/notifications/presentation/widgets/notifications_button.dart';
import 'package:glowguide/features/offers/presentation/widgets/user_offers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserOffersTab extends StatefulWidget {
  const UserOffersTab({super.key});

  @override
  State<UserOffersTab> createState() => _UserOffersTabState();
}

class _UserOffersTabState extends State<UserOffersTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [_appBar(context), const UserOffersList()]),
      ),
    );
  }

  Padding _appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Offers", style: AppTextStyles.heading01SemiBold),
          NotificationsButton(),
        ],
      ),
    );
  }
}
