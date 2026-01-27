import 'package:get_it/get_it.dart';
import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Singleton لـ InternetConnectionChecker
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  await CacheHelper().init();
  sl.registerSingleton<CacheHelper>(CacheHelper());
}
