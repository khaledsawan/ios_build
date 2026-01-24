import 'package:glowguide/features/auth/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required super.refresh,
    required super.access,
    required super.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      refresh: json["refresh"],
      access: json["access"],
      user: UserModel.fromJson(json["user"]),
    );
  }
}

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.type,
    super.profilePic,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "Unknown User ID",
      fullName: json["fullname"] ?? "Unknown",
      email: json["email"] ?? "Unknown User Email",
      type: json["type"] ?? "Unknown User Type",
      profilePic: json["profile_picture"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullname": fullName,
      "email": email,
      "type": type,
      "profile_picture": profilePic,
    };
  }
}
