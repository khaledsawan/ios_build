import 'package:glowguide/features/profile/domain/entities/account_details_entity.dart';

class AccountDetailsModel extends AccountDetailsEntity {
  final String userID;
  final String userType;
  final String businessName;

  AccountDetailsModel({
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.gender,
    required super.birthday,
    required super.profilePic,
    required super.approvedReviews,
    required super.rejectedReviews,
    required this.userID,
    required this.userType,
    required this.businessName,
  });

  factory AccountDetailsModel.fromJson(Map<String, dynamic> json) {
    return AccountDetailsModel(
      userID: json['id'] ?? "",
      name: json['fullname'] ?? "",
      email: json['email'] ?? "",
      userType: json['type'] ?? "",
      profilePic: json['profile_picture'],
      phoneNumber: json['phone_number'] ?? "",
      birthday: json['date_of_birth'],
      gender: json['is_male'],
      businessName: json['business_name'] ?? "",
      approvedReviews: json["approved_review_count"] ?? 0,
      rejectedReviews: json["rejected_review_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": userID,
      "fullname": name,
      "email": email,
      "phone_number": phoneNumber,
      "type": userType,
      "business_name": businessName,
      "profile_picture": profilePic,
      "date_of_birth": birthday,
      "is_male": gender,
      "approved_review_count": approvedReviews,
      "rejected_review_count": rejectedReviews,
    };
  }
}
