import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/offers/domain/entities/create_offer_entity.dart';
import 'package:glowguide/features/offers/domain/repository/offer_repository.dart';
import 'package:dartz/dartz.dart';

class CreateNewOfferUsecase {
  final OfferRepository repository;

  CreateNewOfferUsecase({required this.repository});

  Future<Either<Failure, CreateOfferEntity>> call({
    required CreateOffersParams params,
  }) {
    return repository.createNewOffer(params: params);
  }
}
