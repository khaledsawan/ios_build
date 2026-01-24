import 'dart:convert';

import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/features/profile/data/models/account_details_model.dart';

class AccountDetailsLocalDataSource {
  final CacheHelper cache;
  final String key = "cachedProfile";

  AccountDetailsLocalDataSource({required this.cache});

  void cacheAccountDetails(AccountDetailsModel? accountDetailsToCache) {
    if (accountDetailsToCache != null) {
      cache.saveData(
        key: "CachedAccountDetails",
        value: jsonEncode(accountDetailsToCache.toJson()),
      );
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }

  Future<AccountDetailsModel> getLastAccountDetails() {
    final jsonString = cache.getDataString(key: "CachedAccountDetails");

    if (jsonString != null) {
      return Future.value(AccountDetailsModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }
}
