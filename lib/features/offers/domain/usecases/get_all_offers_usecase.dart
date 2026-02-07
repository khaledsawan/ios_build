import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/features/offers/domain/entities/get_all_offers_entities.dart';
import 'package:glowguide/features/offers/domain/repository/offer_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllOffersUsecase {
  final OfferRepository repository;

  GetAllOffersUsecase({required this.repository});

  Future<Either<Failure, List<GetAllOffersEntities>>> call() {
    return repository.getAllOffers();
  }
}
