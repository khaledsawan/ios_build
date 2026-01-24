class PasswordStates {}

class PasswordInitial extends PasswordStates {}

class ResetPasswordLoading extends PasswordStates {}

class ResetPasswordSuccessfully extends PasswordStates {}

class ResetPasswordFailed extends PasswordStates {
  final String errMessage;

  ResetPasswordFailed({required this.errMessage});
}

class ConfirmResetPasswordLoading extends PasswordStates {}

class ConfirmResetPasswordSuccessfully extends PasswordStates {
  final String tempToken;

  ConfirmResetPasswordSuccessfully({required this.tempToken});
}

class ConfirmResetPasswordFailed extends PasswordStates {
  final String errMessage;

  ConfirmResetPasswordFailed({required this.errMessage});
}

class SetNewPasswordLoading extends PasswordStates {}

class SetNewPasswordSuccessfully extends PasswordStates {}

class SetNewPasswordFailed extends PasswordStates {
  final String errMessage;

  SetNewPasswordFailed({required this.errMessage});
}

class SetNewPasswordByPasswordLoading extends PasswordStates {}

class SetNewPasswordByPasswordSuccessfully extends PasswordStates {}

class SetNewPasswordByPasswordFailed extends PasswordStates {
  final String errMessage;

  SetNewPasswordByPasswordFailed({required this.errMessage});
}
