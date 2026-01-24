import 'package:carousel_slider/carousel_slider.dart';
import 'package:glowguide/features/offers/presentation/cubit/offer_states.dart';
import 'package:glowguide/features/offers/presentation/cubit/offers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StackCarousel extends StatelessWidget {
  const StackCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OffersCubit, OfferStates>(
      builder: (context, state) {
        final cubit = context.read<OffersCubit>();

        return RefreshIndicator(
          onRefresh: () async {
            await cubit.getAllOfferss();
          },
          child: _buildStateUI(state),
        );
      },
    );
  }

  Widget _buildStateUI(OfferStates state) {
    if (state is GetAllOffersLoading) {
      return SizedBox(
        height: 180.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is GetAllOffersFailed) {
      return SizedBox(
        height: 180.h,
        child: Center(
          child: Text(
            state.errMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (state is GetAllOffersSuccessfully) {
      final offers = state.offer;

      if (offers.isEmpty) {
        return SizedBox(
          height: 180.h,
          child: const Center(child: Text("No offers available.")),
        );
      }

      return CarouselSlider.builder(
        itemCount: offers.length,
        itemBuilder: (context, index, realIndex) {
          final offer = offers[index];
          return _offerCard(offer);
        },
        options: CarouselOptions(
          height: 160.h,
          enlargeCenterPage: true,
          autoPlay: true,
          viewportFraction: 0.85,
          enableInfiniteScroll: true,
        ),
      );
    }

    return SizedBox(
      height: 180.h,
      child: const Center(child: Text("Loading...")),
    );
  }

  Widget _offerCard(dynamic offer) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          offer.offerImage != ""
              ? Image.network(offer.offerImage, fit: BoxFit.cover)
              : Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 80,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
