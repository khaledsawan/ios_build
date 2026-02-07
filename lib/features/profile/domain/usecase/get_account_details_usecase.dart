import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/features/profile/domain/entities/account_details_entity.dart';
import 'package:glowguide/features/profile/domain/repos/account_details_repository.dart';
import 'package:dartz/dartz.dart';

class GetAccountDetailsUsecase {
  final AccountDetailsRepository repository;

  GetAccountDetailsUsecase({required this.repository});
  Future<Either<Failure, AccountDetailsEntity>> call() {
    return repository.getAccountDetials();
  }
}
