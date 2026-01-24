import 'dart:convert';

import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/features/clinics/data/models/clinic_model.dart';

class ClinicsLocalDataSource {
  final CacheHelper cache;
  final String key = "cachedClinics";

  ClinicsLocalDataSource({required this.cache});

  void cacheClinics(List<ClinicModel>? clinicsToCache) {
    if (clinicsToCache != null) {
      final jsonList = clinicsToCache.map((clinic) => clinic.toJson()).toList();
      cache.saveData(key: key, value: jsonEncode(jsonList));
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }

  Future<List<ClinicModel>> getLastClinics() async {
    final jsonString = cache.getDataString(key: key);

    if (jsonString != null) {
      final List decodedList = jsonDecode(jsonString) as List;
      return decodedList.map((json) => ClinicModel.fromJson(json)).toList();
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }
}
