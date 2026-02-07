import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_states.dart';

class UserAddLocationPage extends StatefulWidget {
  const UserAddLocationPage({super.key});

  @override
  State<UserAddLocationPage> createState() => _UserAddLocationPageState();
}

class _UserAddLocationPageState extends State<UserAddLocationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isDefault = false;

  @override
  void dispose() {
    _labelController.dispose();
    _floorController.dispose();
    _addressController.dispose();
    _flatController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationsCubit, LocationsStates>(
      listener: (context, state) {
        if (state is AddNewLocationFailed) {
          CustomScaffoldMessenger().showFail(state.errMessage);
        }
        if (state is AddNewLocationSuccessfully) {
          CustomScaffoldMessenger()
              .showSuccess("Location was added successfully");
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddNewLocationLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Location"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInputField(
                    label: "Label",
                    hint: "Home, Work...",
                    controller: _labelController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Label is required" : null,
                  ),
                  SizedBox(height: 16.h),
                  CustomInputField(
                    label: " Address",
                    hint: "Syria, Aleppo, 123 Main St",
                    controller: _addressController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Address is required" : null,
                  ),
                  SizedBox(height: 16.h),
                  CustomInputField(
                    label: "Location Phone Number",
                    hint: "Example: +971 50 123 4567",
                    controller: phoneController,
                    validator: (v) => v == null || v.isEmpty
                        ? "Phone Number is required"
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  CustomInputField(
                    label: "Flat",
                    hint: "A1",
                    controller: _flatController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Flat is required" : null,
                  ),
                  SizedBox(height: 16.h),
                  CustomInputField(
                    label: "Floor",
                    hint: "Example: 2",
                    controller: _floorController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Floor is required" : null,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Set as Default",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: isDefault,
                        onChanged: (value) {
                          setState(() {
                            isDefault = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            final params = AddLocationParams(
                              label: _labelController.text.trim(),
                              floor: _floorController.text.trim(),
                              address: _addressController.text.trim(),
                              flat: _flatController.text.trim(),
                              phoneNumber: phoneController.text,
                              isDefault: isDefault,
                            );

                            final locationsCubit =
                                context.read<LocationsCubit>();

                            await locationsCubit.addNewLocation(params);

                            if (!mounted) return;

                            await locationsCubit.getAllLocations();
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Add New Location"),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
