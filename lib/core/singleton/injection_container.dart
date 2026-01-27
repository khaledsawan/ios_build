import 'package:get_it/get_it.dart';
import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final GetIt sl = GetIt.instance;
final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Singleton لـ InternetConnectionChecker
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Register CacheHelper singleton
  getIt.registerSingleton<CacheHelper>(CacheHelper.instance);
}
