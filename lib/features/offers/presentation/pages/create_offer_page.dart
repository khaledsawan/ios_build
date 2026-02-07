import 'dart:io';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/widgets/add_image_widget.dart';
import 'package:glowguide/core/widgets/custom_scaffold.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/core/widgets/date_input_feild.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:glowguide/features/offers/presentation/cubit/offer_states.dart';
import 'package:glowguide/features/offers/presentation/cubit/offers_cubit.dart';
import 'package:glowguide/features/user/presentation/widgets/user_search_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateOfferPage extends StatefulWidget {
  final ClinicEntity clinicID;

  const CreateOfferPage({super.key, required this.clinicID});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  File? _offerBanner;
  final ImagePicker _picker = ImagePicker();
  List<String> selectedCategories = [];

  Future<void> _pickOfferBanner() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _offerBanner = File(pickedFile.path));
    }
  }

  void _submitOffer() async {
    if (_offerBanner == null) {
      CustomScaffoldMessenger().showFail("Please select offer banner.");
      return;
    }

    if (selectedCategories.isEmpty) {
      CustomScaffoldMessenger().showFail(
        "Please select at least one category.",
      );
      return;
    }

    if (_startDateController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Offer start date is required.");
      return;
    }

    if (_endDateController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Offer end date is required.");
      return;
    }

    final params = CreateOffersParams(
      clinicID: widget.clinicID.clinicId,
      categories: selectedCategories,
      offerBanner: _offerBanner!,
      startDay: _startDateController.text.trim(),
      endDay: _endDateController.text.trim(),
    );

    await context.read<OffersCubit>().createNewOffer(params);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OffersCubit, OfferStates>(
      listener: (context, state) {
        if (state is CreateNewOfferFailed) {
          return CustomScaffoldMessenger().showFail(state.errMessage);
        }

        if (state is CreateNewOfferSuccessfully) {
          return CustomScaffoldMessenger().showSuccess(
            "Offer created successfully!\nWait for admin approval",
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateNewOfferLoading;

        return CustomScaffold(
          safeTop: false,
          children: [
            const SizedBox(height: 20),
            const Text("Create New Offer",
                style: AppTextStyles.heading02ExtraBold),
            const SizedBox(height: 20),
            AddImageWidget(
              title: "Offer Banner",
              selectedImage: _offerBanner,
              onPressed: _offerBanner == null ? _pickOfferBanner : null,
            ),
            const SizedBox(height: 16),
            DateInputField(
              controller: _startDateController,
              label: "Start Date",
            ),
            const SizedBox(height: 16),
            DateInputField(controller: _endDateController, label: "End Date"),
            const SizedBox(height: 16),
            Categories(
              onSelected: (codes) {
                setState(() => selectedCategories = codes);
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : _submitOffer,
              style: isLoading
                  ? Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: WidgetStateProperty.all(Colors.grey),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                  : Theme.of(context).elevatedButtonTheme.style,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Login"),
            ),
          ],
        );
      },
    );
  }
}
