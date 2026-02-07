import 'package:dio/dio.dart';
import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/password/data/models/confirm_reset_password_model.dart';

class PasswordRemoteDataSource {
  final ApiConsumer api;

  PasswordRemoteDataSource({required this.api});

  Future<void> resetPassword(ResetPasswordParams params) async {
    await api.post(EndPoints.resetPassword, data: {"email": params.email});
  }

  Future<ConfirmResetPasswordModel> confirmResetPassword(
      ConfirmResetPasswordParams params) async {
    final response = await api.post(EndPoints.confrimResetPassword,
        data: {"email": params.email, "code": params.otp});

    return ConfirmResetPasswordModel.fromJson(response);
  }

  Future<void> setNewPassword(NewPasswordParams params) async {
    await api.post(
      EndPoints.setNewPassword,
      data: {"password": params.newPassword, "token": params.token},
    );
  }

  Future<void> resetPasswordByPassword(
      ResetPasswordByPasswordParams params) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);

    await api.post(
      EndPoints.resetPasswordByPassword,
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
      data: {
        "old_password": params.oldPassword,
        "new_password": params.newPassword,
      },
    );
  }
}
