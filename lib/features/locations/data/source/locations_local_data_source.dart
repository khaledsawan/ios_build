import 'dart:convert';

import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/features/locations/data/models/locations_model.dart';

class LocationsLocalDataSource {
  final CacheHelper cache;
  final String key = "cachedLocations";

  LocationsLocalDataSource({required this.cache});

  void cacheLocations(List<LocationsModel>? locationsToCache) {
    if (locationsToCache != null) {
      final jsonList = locationsToCache
          .map((locations) => locations.toJson())
          .toList();

      cache.saveData(key: key, value: jsonEncode(jsonList));
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }

  Future<List<LocationsModel>> getLastLocations() async {
    final jsonString = cache.getDataString(key: key);

    if (jsonString != null) {
      final List decodedList = jsonDecode(jsonString) as List;

      return decodedList.map((json) => LocationsModel.fromJson(json)).toList();
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }
}
