import 'dart:convert';

import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/features/clinics/data/models/admin_approve_reject_clinic_model.dart';
import 'package:glowguide/features/clinics/data/models/clinic_model.dart';
import 'package:glowguide/features/clinics/data/models/create_new_clinic_model.dart';
import 'package:dio/dio.dart';

class ClinicsRemoteDataSource {
  final ApiConsumer api;

  ClinicsRemoteDataSource({required this.api});

  Future<List<ClinicModel>> getClinics() async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);

    final response = await api.get(
      EndPoints.getClinics,
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
    );

    final List data = response as List;

    return data.map((json) => ClinicModel.fromJson(json)).toList();
  }

  Future<CreateNewClinicModel> createNewClinic(
    CreateNewClinicParams params,
  ) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);

    final Map<String, dynamic> data = {
      "name": params.clinicName,
      "description": params.clinicDescription,
      "clocation": params.clinicLocation,
      "phone_number": params.clinicPhoneNumber,
      "email": params.clinicEmail,
      "categories": jsonEncode(params.clinicCategories),
      "who_are_we": params.clinicWhoAreWe,
    };
    if (params.commercialImageUrl != null) {
      data["commercial_registration"] = await MultipartFile.fromFile(
        params.commercialImageUrl!.path,
        filename: params.commercialImageUrl!.path.split('/').last,
      );
    }

    if (params.clinicLogoUrl != null) {
      data["clinic_logo"] = await MultipartFile.fromFile(
        params.clinicLogoUrl!.path,
        filename: params.clinicLogoUrl!.path.split('/').last,
      );
    }

    await api.post(
      EndPoints.createClinic,
      options: Options(
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
      ),
      isFormData: true,
      data: data,
    );

    return CreateNewClinicModel();
  }

  Future<AdminApproveRejectClinicModel> adminApproveRejectClinic({
    required AdminApproveRejectClinicParams params,
  }) async {
    final String accessKey = getIt<CacheHelper>().get(ApiKey.access);
    final String clinicID = params.clinicID;

    await api.patch(
      "${EndPoints.adminApproveRejectClinic}$clinicID/manage/",
      options: Options(headers: {"Authorization": "Bearer $accessKey"}),
      data: {"status": params.actionStatus},
    );

    return AdminApproveRejectClinicModel();
  }
}
