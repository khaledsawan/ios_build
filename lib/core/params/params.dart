import 'dart:io';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class SignupUserParams {
  final String fullName;
  final String email;
  final String password;
  final String type;
  final String phoneNumber;
  final String businessName;
  final File? commercialImageUrl;
  final File? profileImageUrl;
  final bool isMale;

  SignupUserParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.type,
    required this.phoneNumber,
    required this.businessName,
    required this.commercialImageUrl,
    required this.profileImageUrl,
    required this.isMale,
  });
}

class UpdateProfileParams {
  final String? fullName;
  final String? phoneNumber;
  final String? birthday;
  final bool? isMale;
  final File? profileImage;

  UpdateProfileParams({
    this.fullName,
    this.phoneNumber,
    this.birthday,
    this.isMale,
    this.profileImage,
  });
}

class CreateNewClinicParams {
  final String clinicName;
  final String clinicDescription;
  final String clinicWhoAreWe;
  final String clinicLocation;
  final String clinicPhoneNumber;
  final String clinicEmail;
  final List<String> clinicCategories;
  final File? commercialImageUrl;
  final File? clinicLogoUrl;

  CreateNewClinicParams({
    required this.clinicName,
    required this.clinicDescription,
    required this.clinicLocation,
    required this.clinicPhoneNumber,
    required this.clinicEmail,
    required this.clinicCategories,
    required this.commercialImageUrl,
    required this.clinicLogoUrl,
    required this.clinicWhoAreWe,
  });
}

class GetClinicByIDParams {
  final String clinicID;

  GetClinicByIDParams({required this.clinicID});
}

class AdminApproveRejectClinicParams {
  final String clinicID;
  final String actionStatus;

  AdminApproveRejectClinicParams({
    required this.clinicID,
    required this.actionStatus,
  });
}

class NotificationParams {
  final String recipient;
  final String content;

  NotificationParams({required this.recipient, required this.content});
}

class AdminApproveRejectReviewParams {
  final String reviewID;
  final String actionStatus;

  AdminApproveRejectReviewParams({
    required this.reviewID,
    required this.actionStatus,
  });
}

class WriteReviewParams {
  final String clinicID;
  final int rating;
  final String reviewText;

  WriteReviewParams({
    required this.clinicID,
    required this.rating,
    required this.reviewText,
  });
}

class GetReviewsByClinicIDParams {
  final String clinicID;

  GetReviewsByClinicIDParams({required this.clinicID});
}

class CreateOffersParams {
  final String clinicID;
  final List<String> categories;
  final File offerBanner;
  final String startDay;
  final String endDay;
  final bool isHidden;

  CreateOffersParams({
    required this.clinicID,
    required this.categories,
    required this.offerBanner,
    required this.startDay,
    required this.endDay,
    this.isHidden = false,
  });
}

class AdminApproveRejectOffersParams {
  final String offerID;
  final String action;

  AdminApproveRejectOffersParams({required this.offerID, required this.action});
}

class UserNameLogoParams {
  final String userID;

  UserNameLogoParams({required this.userID});
}

class ResetPasswordParams {
  final String email;

  ResetPasswordParams({required this.email});
}

class ConfirmResetPasswordParams {
  final String email;
  final String otp;

  ConfirmResetPasswordParams({required this.email, required this.otp});
}

class NewPasswordParams {
  final String newPassword;
  final String token;

  NewPasswordParams({required this.newPassword, required this.token});
}

class ResetPasswordByPasswordParams {
  final String oldPassword;
  final String newPassword;

  ResetPasswordByPasswordParams(
      {required this.oldPassword, required this.newPassword});
}

class AddLocationParams {
  final String label;
  final String floor;
  final String address;
  final String flat;
  final bool isDefault;
  final String phoneNumber;

  AddLocationParams(
      {required this.label,
      required this.floor,
      required this.address,
      required this.flat,
      required this.isDefault,
      required this.phoneNumber});
}

class DeleteLocationParams {
  final String locationId;

  DeleteLocationParams({required this.locationId});
}

class DeleteAccountParams {
  final String email;
  final String password;

  DeleteAccountParams({required this.email, required this.password});
}
