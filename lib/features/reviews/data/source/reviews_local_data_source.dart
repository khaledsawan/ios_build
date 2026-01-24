import 'dart:convert';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/errors/expentions.dart';
import 'package:glowguide/features/reviews/data/models/reviews_model.dart';

class ReviewsLocalDataSource {
  final CacheHelper cache;
  final String cachedReviewsKey = "cachedReviews";

  ReviewsLocalDataSource({required this.cache});

  void cacheReviews(List<ReviewsModel>? reviewssToCache) {
    if (reviewssToCache != null) {
      final jsonList = reviewssToCache
          .map((reviews) => reviews.toJson())
          .toList();
      cache.saveData(key: cachedReviewsKey, value: jsonEncode(jsonList));
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }

  Future<List<ReviewsModel>> getLastReviews() async {
    final jsonString = cache.getDataString(key: cachedReviewsKey);

    if (jsonString != null) {
      final List decodedList = jsonDecode(jsonString) as List;
      return decodedList.map((json) => ReviewsModel.fromJson(json)).toList();
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection!");
    }
  }
}
