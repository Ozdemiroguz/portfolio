import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../shared/domain/models/user_model.dart';
import '../../../shared/data/services/firestore_service.dart';
import '../services/auth_service.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepositoryImpl(this._authService, this._firestoreService);

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _authService.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _authService.updateDisplayName(displayName);

    final user = credential.user!;
    final userModel = UserModel(
      id: user.uid,
      displayName: displayName,
      email: email,
      createdAt: DateTime.now(),
      portfolios: [],
    );

    await _firestoreService.setDocument(
      collection: 'users',
      docId: user.uid,
      data: userModel.toJson(),
    );

    return credential;
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestoreService.getDocument(
      collection: 'users',
      docId: user.uid,
    );

    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestoreService.updateDocument(
      collection: 'users',
      docId: userId,
      data: data,
    );
  }
}
