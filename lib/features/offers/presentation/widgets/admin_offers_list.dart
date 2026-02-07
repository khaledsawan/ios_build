import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/offers/presentation/cubit/offer_states.dart';
import 'package:glowguide/features/offers/presentation/cubit/offers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOffersList extends StatelessWidget {
  const AdminOffersList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OffersCubit>();

    return Expanded(
      child: BlocConsumer<OffersCubit, OfferStates>(
        listener: (context, state) {
          if (state is AdminApproveRejectOfferSuccessfully) {
            CustomScaffoldMessenger().showSuccess("Success!");
            cubit.getAllOfferss();
          }

          if (state is AdminApproveRejectOfferFailed) {
            CustomScaffoldMessenger().showFail(state.errMessage);
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getAllOfferss();
            },
            child: _buildStateUI(state, context),
          );
        },
      ),
    );
  }

  Widget _buildStateUI(OfferStates state, BuildContext context) {
    if (state is GetAllOffersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllOffersFailed) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                state.errMessage,
                style: const TextStyle(color: Colors.red),
              ),
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
            SizedBox(height: 50),
            Center(child: Text("No offers available.")),
          ],
        );
      }

      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: offers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 32),
        itemBuilder: (context, index) {
          final offer = offers[index];

          return Column(
            children: [
              SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: offer.offerImage.isNotEmpty
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
                          "Thinking About Trying a New Salon?",
                          style: AppTextStyles.paragraph01SemiBold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: SizedBox(
                        width: 165,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("See more!"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final params = AdminApproveRejectOffersParams(
                          offerID: offer.offerID,
                          action: "APPROVED",
                        );
                        await context
                            .read<OffersCubit>()
                            .adminApproveRejectOffers(params);

                        if (context.mounted) {
                          await context.read<OffersCubit>().getAllOfferss();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.success12,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            "Approve",
                            style: AppTextStyles.paragraph02Regular.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final cubit = context.read<OffersCubit>();

                        final params = AdminApproveRejectOffersParams(
                          offerID: offer.offerID,
                          action: "REJECTED",
                        );
                        await cubit.adminApproveRejectOffers(params);
                        await cubit.getAllOfferss();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: AppColors.error12,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            "Decline",
                            style: AppTextStyles.paragraph02Regular.copyWith(
                              color: AppColors.error12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 200),
        Center(child: Text("Pull down to load offers")),
      ],
    );
  }
}
