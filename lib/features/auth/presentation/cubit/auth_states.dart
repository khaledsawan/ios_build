import 'package:glowguide/features/auth/domain/entities/login_entity.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginUserLoading extends AuthStates {}

class LoginUserSuccessfully extends AuthStates {
  final LoginEntity user;

  LoginUserSuccessfully({required this.user});
}

class LoginUserFailed extends AuthStates {
  final String errMessage;

  LoginUserFailed({required this.errMessage});
}

class SignupUserLoading extends AuthStates {}

class SignupUserSuccess extends AuthStates {}

class SignupUserFailed extends AuthStates {
  final String errMessage;

  SignupUserFailed({required this.errMessage});
}
