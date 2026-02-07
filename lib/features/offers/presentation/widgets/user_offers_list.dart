import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/presentation/pages/clinic_details_page.dart';
import 'package:glowguide/features/offers/presentation/cubit/offer_states.dart';
import 'package:glowguide/features/offers/presentation/cubit/offers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserOffersList extends StatelessWidget {
  const UserOffersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<OffersCubit, OfferStates>(
        builder: (context, state) {
          final cubit = context.read<OffersCubit>();

          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getAllOfferss();
            },
            child: _buildStateUI(state),
          );
        },
      ),
    );
  }

  Widget _buildStateUI(OfferStates state) {
    if (state is GetAllOffersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllOffersFailed) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 200),
          Center(
            child: Text(
              state.errMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    }

    if (state is GetAllOffersSuccessfully) {
      final offers = state.offer;

      if (offers.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(child: Text("No offers available.")),
          ],
        );
      }

      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: offers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final offer = offers[index];

          return SizedBox(
            height: 150,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: offer.offerImage != ""
                        ? Image.network(offer.offerImage, fit: BoxFit.cover)
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 95,
                              ),
                            ),
                          ),
                  ),
                ),
                const Positioned(
                  top: 16,
                  left: 16,
                  child: SizedBox(
                    width: 165,
                    child: Text(
                      "Thinking About Trying a New Salon? ",
                      style: AppTextStyles.paragraph01SemiBold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClinicDetailsPage(clinic: offer.clinicDetails),
                          ),
                        );
                      },
                      child: const Text("Go to clinic"),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // Default initial state (empty)
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 200),
        Center(child: Text("Pull down to load offers")),
      ],
    );
  }
}
