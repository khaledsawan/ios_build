import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/offers/domain/entities/admin_approve_reject_offer_entity.dart';
import 'package:glowguide/features/offers/domain/entities/create_offer_entity.dart';
import 'package:glowguide/features/offers/domain/entities/get_all_offers_entities.dart';
import 'package:dartz/dartz.dart';

abstract class OfferRepository {
  Future<Either<Failure, CreateOfferEntity>> createNewOffer({
    required CreateOffersParams params,
  });

  Future<Either<Failure, List<GetAllOffersEntities>>> getAllOffers();

  Future<Either<Failure, AdminApproveRejectOfferEntity>>
  adminApproveRejectOffers({required AdminApproveRejectOffersParams params});
}
