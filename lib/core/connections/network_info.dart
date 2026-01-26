import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl(this._connectionChecker);

  @override
  Future<bool> get isConnected async {
    try {
      // هذا يتحقق من اتصال الإنترنت الفعلي وليس فقط الشبكة
      return await _connectionChecker.hasConnection;
    } catch (e) {
      // لو صار أي خطأ، يرجع false بدل ما يكرش التطبيق
      return false;
    }
  }
}
