import 'package:glowguide/features/user/domain/entities/user_name_logo_entity.dart';

class UserNameLogoModel extends UserNameLogoEntity {
  UserNameLogoModel({required super.fullName, super.profilePicture});

  factory UserNameLogoModel.fromJson(Map<String, dynamic> json) {
    return UserNameLogoModel(
      fullName: json['fullname'] ?? '',
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'fullname': fullName, 'profile_picture': profilePicture};
  }
}
