class LoginEntity {
  final String access;
  final String refresh;
  final UserEntity user;

  LoginEntity({
    required this.access,
    required this.refresh,
    required this.user,
  });
}

class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String type;
  final String? profilePic;

  UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.type,
    this.profilePic,
  });
}
