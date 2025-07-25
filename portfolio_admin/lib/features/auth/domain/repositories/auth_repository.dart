import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/domain/models/user_model.dart';

abstract class AuthRepository {
  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<UserModel?> getCurrentUserData();

  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  });
}
