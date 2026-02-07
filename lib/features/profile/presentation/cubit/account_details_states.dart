import 'package:glowguide/features/profile/domain/entities/account_details_entity.dart';

class AccountDetailsStates {}

final class AccountDetailsInitial extends AccountDetailsStates {}

final class GetAccountDetailsSuccessfully extends AccountDetailsStates {
  final AccountDetailsEntity accountDetails;

  GetAccountDetailsSuccessfully({required this.accountDetails});
}

final class GetAccountDetailsLoading extends AccountDetailsStates {}

final class GetAccountDetailsFailure extends AccountDetailsStates {
  final String errMessage;

  GetAccountDetailsFailure({required this.errMessage});
}

final class UpdateProfileLoading extends AccountDetailsStates {}

final class UpdateProfileSuccessfully extends AccountDetailsStates {}

final class UpdateProfileFailed extends AccountDetailsStates {
  final String errMessage;

  UpdateProfileFailed({required this.errMessage});
}
