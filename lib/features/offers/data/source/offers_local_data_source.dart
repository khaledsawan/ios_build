import 'dart:convert';

import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/features/offers/data/models/get_all_offer_model.dart';

class OffersLocalDataSource {
  final CacheHelper cache;
  final String key = "CachedOffers";

  OffersLocalDataSource({required this.cache});

  void cacheOffers(List<GetAllOfferModel>? offers) {
    if (offers != null) {
      final encoded = jsonEncode(
        offers.map((offers) => offers.toJson()).toList(),
      );
      cache.saveData(key: key, value: encoded);
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }

  Future<List<GetAllOfferModel>> getLastOffers() async {
    final jsonString = cache.getDataString(key: key);

    if (jsonString != null) {
      final List decodedList = jsonDecode(jsonString) as List;
      return decodedList
          .map((json) => GetAllOfferModel.fromJson(json))
          .toList();
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }
}
