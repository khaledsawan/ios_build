import 'dart:convert';

import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/features/profile/data/models/account_details_model.dart';

class AccountDetailsLocalDataSource {
  final CacheHelper cache;

  static const String cachedAccountDetailsKey = "CachedAccountDetails";

  AccountDetailsLocalDataSource({required this.cache});

  /// SAVE
  void cacheAccountDetails(AccountDetailsModel accountDetailsToCache) {
    cache.save(
      key: cachedAccountDetailsKey,
      value: jsonEncode(accountDetailsToCache.toJson()),
    );
  }

  /// GET
  Future<AccountDetailsModel> getLastAccountDetails() async {
    final jsonString = cache.get<String>(cachedAccountDetailsKey);

    if (jsonString != null) {
      return AccountDetailsModel.fromJson(
        jsonDecode(jsonString),
      );
    } else {
      throw CacheExeption(errorMessage: "No cached data found");
    }
  }
}
