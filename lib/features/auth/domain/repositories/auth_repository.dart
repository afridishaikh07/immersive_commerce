import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password, String name);
  Future<void> signOut();
  Future<void> updateProfile(User user);
  Future<bool> isAuthenticated();
}
