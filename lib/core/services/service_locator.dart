import 'package:get_it/get_it.dart';
import 'package:glowguide/core/connections/network_info.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerSingleton<CacheHelper>(
    CacheHelper(prefs),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );
}
