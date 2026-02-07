import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';

abstract class ClinicsState {}

class ClinicsInitial extends ClinicsState {}

class GetClinicsLoading extends ClinicsState {}

class GetClinicsSuccessfully extends ClinicsState {
  final List<ClinicEntity> clinics;

  GetClinicsSuccessfully({required this.clinics});
}

class GetClinicsFailed extends ClinicsState {
  final String errMessage;

  GetClinicsFailed({required this.errMessage});
}

class CreateNewClinicLoading extends ClinicsState {}

class CreateNewClinicSuccess extends ClinicsState {}

class CreateNewClinicFailed extends ClinicsState {
  final String errMessage;

  CreateNewClinicFailed({required this.errMessage});
}

class AdminApproveRejectClinicLoading extends ClinicsState {}

class AdminApproveRejectClinicSuccessfully extends ClinicsState {}

class AdminApproveRejectClinicFailed extends ClinicsState {
  final String errMessage;

  AdminApproveRejectClinicFailed({required this.errMessage});
}

class GetClinicByIDLoading extends ClinicsState {}

class GetClinicByIDSuccessfully extends ClinicsState {
  final ClinicEntity clinic;

  GetClinicByIDSuccessfully({required this.clinic});
}

class GetClinicByIDFailed extends ClinicsState {
  final String errMessage;

  GetClinicByIDFailed({required this.errMessage});
}
