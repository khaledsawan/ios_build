import 'package:glowguide/features/auth/domain/entities/sign_up_clinic_owner_entity.dart';

class SignUpClinicOwnerModel extends SignUpClinicOwnerEntity {
  final String successMessage;

  SignUpClinicOwnerModel({required this.successMessage});

  factory SignUpClinicOwnerModel.fromJson(Map<String, dynamic> json) {
    return SignUpClinicOwnerModel(successMessage: json["message"]);
  }

  Map<String, dynamic> toJson() {
    return {"message": successMessage};
  }
}
