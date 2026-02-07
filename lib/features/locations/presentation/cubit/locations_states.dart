import 'package:glowguide/features/locations/domain/entities/location_entity.dart';

abstract class LocationsStates {}

class LocationsInitial extends LocationsStates {}

class GetAllLocationsLoading extends LocationsStates {}

class GetAllLocationsSuccessfully extends LocationsStates {
  final List<LocationEntity> location;

  GetAllLocationsSuccessfully({required this.location});
}

class GetAllLocationsFailed extends LocationsStates {
  final String errMessage;

  GetAllLocationsFailed({required this.errMessage});
}

class AddNewLocationLoading extends LocationsStates {}

class AddNewLocationSuccessfully extends LocationsStates {}

class AddNewLocationFailed extends LocationsStates {
  final String errMessage;

  AddNewLocationFailed({required this.errMessage});
}

class DeleteLocationLoading extends LocationsStates {}

class DeleteLocationSuccessfully extends LocationsStates {}

class DeleteLocationFailed extends LocationsStates {
  final String errMessage;
  DeleteLocationFailed({required this.errMessage});
}
