import 'package:glowguide/features/password/domain/entities/confirm_reset_password_entity.dart';

class ConfirmResetPasswordModel extends ConfirmResetPasswordEntity {
  ConfirmResetPasswordModel({required super.tempToken});

  /// Factory constructor to create a model from JSON
  factory ConfirmResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ConfirmResetPasswordModel(
      tempToken: json['temp_token'] as String, // adjust key if API is different
    );
  }

  /// Convert model to JSON (useful when sending data to the API)
  Map<String, dynamic> toJson() {
    return {
      'temp_token': tempToken,
    };
  }
}
