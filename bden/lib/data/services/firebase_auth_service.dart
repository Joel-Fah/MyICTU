import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../../core/enums/user_role.dart';
import '../../core/enums/auth_provider_type.dart';
import '../../core/errors/auth_exception.dart';

class FirebaseAuthService extends GetxService implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const AuthException('Sign in cancelled');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      final firebaseUser = result.user!;

      // Check if user already exists in Firestore
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }

      // Create new user document
      final now = DateTime.now();
      final user = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        role: UserRole.donor, // default; updated after role selection
        authProvider: AuthProviderType.google,
        createdAt: now,
        updatedAt: now,
      );
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Auth failed', code: e.code);
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc =
          await _firestore.collection('users').doc(result.user!.uid).get();
      if (!doc.exists) throw const AuthException('Account not found');
      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Auth failed', code: e.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(user.copyWith(updatedAt: DateTime.now()).toJson());
  }

  @override
  UserModel? getCurrentUser() => null; // resolved via authStateChanges

  @override
  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }
}
