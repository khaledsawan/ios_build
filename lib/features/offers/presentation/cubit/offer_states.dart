import 'package:glowguide/features/offers/domain/entities/get_all_offers_entities.dart';

abstract class OfferStates {}

class OffersInitial extends OfferStates {}

class CreateNewOfferLoading extends OfferStates {}

class CreateNewOfferSuccessfully extends OfferStates {}

class CreateNewOfferFailed extends OfferStates {
  final String errMessage;

  CreateNewOfferFailed({required this.errMessage});
}

class GetAllOffersLoading extends OfferStates {}

class GetAllOffersSuccessfully extends OfferStates {
  final List<GetAllOffersEntities> offer;

  GetAllOffersSuccessfully({required this.offer});
}

class GetAllOffersFailed extends OfferStates {
  final String errMessage;

  GetAllOffersFailed({required this.errMessage});
}

class AdminApproveRejectOfferLoading extends OfferStates {}

class AdminApproveRejectOfferSuccessfully extends OfferStates {}

class AdminApproveRejectOfferFailed extends OfferStates {
  final String errMessage;

  AdminApproveRejectOfferFailed({required this.errMessage});
}
