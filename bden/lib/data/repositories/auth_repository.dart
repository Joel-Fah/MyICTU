import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> updateUserProfile(UserModel user);
  UserModel? getCurrentUser();
  Stream<UserModel?> authStateChanges();
}
