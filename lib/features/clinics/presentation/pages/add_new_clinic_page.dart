import 'dart:io';

import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/auth/presentation/widgets/phone_input.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_state.dart';
import 'package:glowguide/core/widgets/add_image_widget.dart';
import 'package:glowguide/features/user/presentation/widgets/user_search_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddNewClinicPage extends StatefulWidget {
  const AddNewClinicPage({super.key});

  @override
  State<AddNewClinicPage> createState() => _AddNewClinicPageState();
}

final _clinicNameController = TextEditingController();
final _cliniDescriptionController = TextEditingController();
final _cliniWhoAreWeController = TextEditingController();
final _clinicLocaitonController = TextEditingController();
final _clinicPhoneNumberController = TextEditingController();
final _clinicEmailController = TextEditingController();

List<String> selectedCategories = [];

File? _clinicLogo;
File? _clinicCommercialRegisteration;
final ImagePicker _picker = ImagePicker();

class _AddNewClinicPageState extends State<AddNewClinicPage> {
  Future<void> _pickClinicLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _clinicLogo = File(pickedFile.path));
    }
  }

  Future<void> _pickCommercialImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _clinicCommercialRegisteration = File(pickedFile.path));
    }
  }

  void _submit() {
    if (_clinicLogo == null || _clinicCommercialRegisteration == null) {
      CustomScaffoldMessenger().showFail("Please select both images.");
      return;
    }

    if (_clinicNameController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Clinic name is required.");
      return;
    }

    if (_cliniDescriptionController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Clinic description is required.");
      return;
    }

    if (_cliniWhoAreWeController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Who are we sections is required.");
      return;
    }

    if (_clinicPhoneNumberController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Clinic phone number is required.");
      return;
    }

    if (_clinicEmailController.text.trim().isEmpty) {
      CustomScaffoldMessenger().showFail("Clinic email is required.");
      return;
    }
    final params = CreateNewClinicParams(
      clinicName: _clinicNameController.text.trim(),
      clinicDescription: _cliniDescriptionController.text.trim(),
      clinicLocation: _clinicLocaitonController.text.trim(),
      clinicWhoAreWe: _cliniWhoAreWeController.text.trim(),
      clinicPhoneNumber: _clinicPhoneNumberController.text.trim(),
      clinicEmail: _clinicEmailController.text.trim(),
      clinicCategories: selectedCategories,
      commercialImageUrl: _clinicCommercialRegisteration,
      clinicLogoUrl: _clinicLogo,
    );

    context.read<ClinicsCubit>().createNewClinic(params);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicsCubit, ClinicsState>(
      listener: (context, state) {
        if (state is CreateNewClinicSuccess) {
          CustomScaffoldMessenger().showSuccess(
            "Your clinic was created successfully!\nWait for admin approval",
          );

          Navigator.pop(context);
        }

        if (state is CreateNewClinicFailed) {
          CustomScaffoldMessenger().showFail(state.errMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateNewClinicLoading;

        return Scaffold(
          appBar: _appBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Column(
                    children: [
                      CustomInputField(
                        label: "Clinic Name",
                        hint: "Enter ...",
                        controller: _clinicNameController,
                      ),
                      SizedBox(height: 16.h),
                      CustomInputField(
                        label: "Clinic Description",
                        hint: "Enter ...",
                        controller: _cliniDescriptionController,
                      ),
                      SizedBox(height: 16.h),
                      CustomInputField(
                        label: "Who are we?",
                        hint: "Enter ...",
                        maxLines: 5,
                        controller: _cliniWhoAreWeController,
                      ),
                      SizedBox(height: 16.h),
                      CustomInputField(
                        label: "Clinic Location",
                        hint: "Enter ...",
                        controller: _clinicLocaitonController,
                      ),
                      SizedBox(height: 16.h),
                      PhoneInputField(
                        controller: _clinicPhoneNumberController,
                        label: "Phone Number",
                      ),
                      SizedBox(height: 16.h),
                      CustomInputField(
                        label: "Clinic Email",
                        hint: "Enter ...",
                        controller: _clinicEmailController,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AddImageWidget(
                    title: "Commercial Registration",
                    selectedImage: _clinicCommercialRegisteration,
                    onPressed: () {
                      _pickCommercialImage();
                    },
                  ),
                  SizedBox(height: 16.h),
                  AddImageWidget(
                    title: "Clinic Logo",
                    selectedImage: _clinicLogo,
                    onPressed: () {
                      _pickClinicLogo();
                    },
                  ),
                  SizedBox(height: 16.h),
                  Categories(
                    onSelected: (categories) {
                      selectedCategories = categories;
                    },
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: isLoading
                        ? Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.grey,
                              ),
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
                        : const Text("Add Clinic"),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text("Add New Clinic", style: AppTextStyles.paragraph02SemiBold),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.close, size: 24, color: Color(0xFFDD0011)),
                SizedBox(width: 8.w),
                Text(
                  "Cancel",
                  style: AppTextStyles.paragraph01SemiBold.copyWith(
                    color: const Color(0xFFDD0011),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
