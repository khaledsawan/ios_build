import 'package:flutter/widgets.dart';
import 'package:glowguide/core/databases/api/api_consumer.dart';
import 'package:glowguide/core/databases/api/end_points.dart';
import 'package:glowguide/core/databases/cache/cache_helper.dart';
import 'package:glowguide/core/singleton/injection_container.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '105652923204-59sd5sj26v3josk213dfs5bves21r46t.apps.googleusercontent.com',
  );

  Future<String?> signInAndGetIdToken() async {
    final user = await _googleSignIn.signIn();
    if (user == null) return null;

    final auth = await user.authentication;
    return auth.idToken;
  }

  /// Sign out the last session
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      // print('Previous Google session signed out');
    } catch (e) {
      // print('Error signing out: $e');
    }
  }
}

class GoogleAuthRemoteDataSource {
  final ApiConsumer api;

  GoogleAuthRemoteDataSource(this.api);

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await api.post(
      EndPoints.google,
      data: {
        'id_token': idToken,
      },
    );

    return Map<String, dynamic>.from(response ?? {});
  }
}

class GoogleAuthRepository {
  final GoogleAuthRemoteDataSource remote;

  GoogleAuthRepository(this.remote);

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await remote.loginWithGoogle(idToken);

    final accessToken = response['access'];
    final refreshToken = response['refresh'];
    final user = response['user'] ?? {};

    // Save tokens & user info
    final accessSaved = await sl<CacheHelper>()
        .saveData(key: ApiKey.access, value: accessToken);
    await sl<CacheHelper>().saveData(key: ApiKey.refresh, value: refreshToken);
    await sl<CacheHelper>().saveData(key: ApiKey.userID, value: user['id']);
    await sl<CacheHelper>().saveData(key: ApiKey.type, value: "U");
    await sl<CacheHelper>()
        .saveData(key: ApiKey.userFullName, value: user['fullname']);
    await sl<CacheHelper>()
        .saveData(key: ApiKey.userEmail, value: user['email']);
    if (user['profile_pic'] != null) {
      await sl<CacheHelper>()
          .saveData(key: ApiKey.userProfileImage, value: user['profile_pic']);
    }

    debugPrint('Access token: $accessToken, saved successfully? $accessSaved');

    return {
      'user': user,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
