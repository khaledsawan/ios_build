import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/offers/presentation/widgets/admin_offers_list.dart';
import 'package:flutter/material.dart';

class AdminOffersTab extends StatelessWidget {
  const AdminOffersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pending Offers", style: AppTextStyles.paragraph01SemiBold),

        AdminOffersList(),
      ],
    );
  }
}
