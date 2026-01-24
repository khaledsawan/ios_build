abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {}

class DeleteAccountFailed extends DeleteAccountState {
  final String errMessage;

  DeleteAccountFailed({required this.errMessage});
}
