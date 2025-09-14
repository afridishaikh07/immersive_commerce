import 'dart:convert';
import 'package:immersive_commerce/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<bool> isUserCached();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(AppConstants.userKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(AppConstants.userKey, userJson);
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(AppConstants.userKey);
  }

  @override
  Future<bool> isUserCached() async {
    return sharedPreferences.containsKey(AppConstants.userKey);
  }
}
