import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_groceries/features/authentication/domain/entities/auth_user_entity.dart';

abstract class AuthRemoteFirebase {
  FirebaseAuth get auth;

  Stream<AuthUserEntity?> get user;

  Future<AuthUserEntity> signUpWithEmailAndPassword(
      {required String email, required String password});

  Future<AuthUserEntity> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<void> signOut();
}
