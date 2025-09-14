import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const _usersKey = 'users';

  Future<List<Map<String, dynamic>>> _getStoredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson
        .map((user) => jsonDecode(user) as Map<String, dynamic>)
        .toList();
  }

  Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((user) => jsonEncode(user)).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    final users = await _getStoredUsers();
    final existingUser = users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );

    if (existingUser.isNotEmpty) {
      return UserModel.fromJson(existingUser);
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    final users = await _getStoredUsers();

    final exists = users.any((user) => user['email'] == email);
    if (exists) {
      throw Exception('User already exists');
    }

    final newUser = UserModel(
      id: Random().nextInt(10000).toString(),
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );

    users.add(newUser.toJson());
    await _saveUsers(users);

    return newUser;
  }
}
