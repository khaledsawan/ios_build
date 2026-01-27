import 'package:get_it/get_it.dart';
import 'package:glowguide/core/connections/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Singleton لـ InternetConnectionChecker
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // Singleton لـ NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}
