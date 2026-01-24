import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/offers/domain/entities/admin_approve_reject_offer_entity.dart';
import 'package:glowguide/features/offers/domain/repository/offer_repository.dart';
import 'package:dartz/dartz.dart';

class AdminApproveRejectOffersUsecase {
  final OfferRepository repository;

  AdminApproveRejectOffersUsecase({required this.repository});

  Future<Either<Failure, AdminApproveRejectOfferEntity>> call({
    required AdminApproveRejectOffersParams params,
  }) {
    return repository.adminApproveRejectOffers(params: params);
  }
}
