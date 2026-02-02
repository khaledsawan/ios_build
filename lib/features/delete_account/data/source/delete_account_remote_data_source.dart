import 'package:dio/dio.dart';
import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/singleton/injection_container.dart';

class DeleteAccountRemoteDataSource {
  final ApiConsumer api;

  DeleteAccountRemoteDataSource({required this.api});

  Future<void> deleteAccount(DeleteAccountParams params) async {
    final String? accessKey = sl<CacheHelper>().getData(key: ApiKey.access);

    await api.delete(EndPoints.deleteAccount, null,
        options: Options(headers: {
          if (accessKey != null) "Authorization": "Bearer $accessKey"
        }),
        data: {
          "email": params.email,
          "password": params.password,
        });
  }
}
