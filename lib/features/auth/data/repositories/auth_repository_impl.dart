import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User?> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      return cachedUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final userModel = await remoteDataSource.signIn(email, password);
      await localDataSource.cacheUser(userModel);
      return userModel;
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<User> signUp(String email, String password, String name) async {
    try {
      final userModel = await remoteDataSource.signUp(email, password, name);
      await localDataSource.cacheUser(userModel);
      return userModel;
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await localDataSource.clearCache();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfile(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await localDataSource.cacheUser(userModel);
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await localDataSource.isUserCached();
    } catch (e) {
      return false;
    }
  }
}
