import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/params/params.dart';
import 'package:glowguide/features/auth/data/models/login_model.dart';
import 'package:glowguide/features/auth/data/models/sign_up_clinic_owner_model.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final ApiConsumer api;

  AuthRemoteDataSource({required this.api});

  Future<LoginModel> loginUser(LoginParams params) async {
    final response = await api.post(
      EndPoints.login,
      data: {"email": params.email, "password": params.password},
    );

    return LoginModel.fromJson(response);
  }

  Future<SignUpClinicOwnerModel> signupUser(SignupUserParams params) async {
    final Map<String, dynamic> data = {
      "fullname": params.fullName,
      "email": params.email,
      "password": params.password,
      "type": params.type,
      "phone_number": params.phoneNumber,
      "business_name": params.businessName,
      "is_male": params.isMale ? 1 : 0,
    };

    if (params.commercialImageUrl != null) {
      data["commercial_reg"] = await MultipartFile.fromFile(
        params.commercialImageUrl!.path,
        filename: params.commercialImageUrl!.path.split('/').last,
      );
    }

    if (params.profileImageUrl != null) {
      data["profile_picture"] = await MultipartFile.fromFile(
        params.profileImageUrl!.path,
        filename: params.profileImageUrl!.path.split('/').last,
      );
    }

    final response = await api.post(
      EndPoints.signupUser,
      isFormData: true,
      data: data,
    );

    return SignUpClinicOwnerModel.fromJson(response);
  }
}
