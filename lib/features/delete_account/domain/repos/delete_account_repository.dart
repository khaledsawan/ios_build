import 'package:dartz/dartz.dart';
import 'package:glowguide/core/errors/failure.dart';
import 'package:glowguide/core/params/params.dart';

abstract class DeleteAccountRepository {
  Future<Either<Failure, void>> deleteAccount(
      {required DeleteAccountParams params});
}
