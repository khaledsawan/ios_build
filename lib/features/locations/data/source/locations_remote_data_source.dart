import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/locations/data/models/locations_model.dart';
import 'package:dio/dio.dart';

class LocationsRemoteDataSource {
  final ApiConsumer api;

  LocationsRemoteDataSource({required this.api});

  Future<List<LocationsModel>> getAllLocations() async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);

    final response = await api.get(
      EndPoints.getAllLocations,
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
    );

    final List data = response as List;

    return data.map((json) => LocationsModel.fromJson(json)).toList();
  }

  Future<void> addNewLocation(AddLocationParams params) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);
    await api.post(EndPoints.getAllLocations,
        options: Options(headers: {"Authorization": "Bearer $accessKey"}),
        data: {
          "label": params.label,
          "floor": params.floor,
          "address": params.address,
          "flat": params.flat,
          "phone_number": params.phoneNumber,
          "is_default": params.isDefault
        });
  }

  Future<void> deleteLocation(DeleteLocationParams params) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);

    await api.delete("${EndPoints.getAllLocations}/${params.locationId}", null,
        options: Options(headers: {"Authorization": "Bearer $accessKey"}));
  }
}
