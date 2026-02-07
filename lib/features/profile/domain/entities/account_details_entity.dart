class AccountDetailsEntity {
  final String name;
  final String email;
  final String phoneNumber;
  final bool gender;
  final String? birthday;
  final String? profilePic;
  final int approvedReviews;
  final int rejectedReviews;

  AccountDetailsEntity({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.birthday,
    required this.profilePic,
    required this.approvedReviews,
    required this.rejectedReviews,
  });
}
