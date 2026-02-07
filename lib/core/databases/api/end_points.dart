class EndPoints {
  // normalized base URL (lowercase scheme, include trailing slash)
  static const String baseUrl = 'https://glowguide.ae/';

  static const String accountDetails = "user/profile/";
  static const String login = "user/login/";
  static const String signupUser = "user/signup/";
  static const String google = "user/google/";

  static const String getNotifications = "notification/notifications/";
  static const String createNotification = "notification/notifications/create/";

  static const String getClinics = "clinic/clinics/";
  static const String createClinic = "clinic/clinics/request/";
  static const String adminApproveRejectClinic = "clinic/clinics/";

  static const String writeReview = "review/reviews/create/";
  static const String getAllReviews = "review/reviews/";
  static const String adminApproveRejectReview = "review/reviews/";
  static const String review = "review/CreateReview/";
  static const String getReviewsByClinicID = "review/reviews/clinic/";

  static const String getAllFavorites = "ufavorites/favorites/";
  static const String addClinicToFavorite = "ufavorites/favorites/add/";
  static const String removeClinicFromFavorite = "ufavorites/favorites/";

  static const String createNewOffer = "/offers/offers/create/";
  static const String getAllOffers = "/offers/offers/";

  static const String getUserNameLogo = "/user/logo/";

  static const String getAllLocations = "/location/locations/";

  static const String resetPassword = "/user/request-reset/";
  static const String confrimResetPassword = "/user/verify-reset/";
  static const String setNewPassword = "/user/reset-password/";
  static const String resetPasswordByPassword = "/user/change-password/";

  static const String deleteAccount = "/user/delete-account/";
}

class ApiKey {
  static const String access = "access";
  static const String refresh = "refresh";
  static const String userID = "id";
  static const String type = "type";
  static const String userFullName = "userFullName";
  static const String userEmail = "userEmail";
  static const String userProfileImage = "userProfileImage";
  static const String mainLocation = "mainLocation";
}
