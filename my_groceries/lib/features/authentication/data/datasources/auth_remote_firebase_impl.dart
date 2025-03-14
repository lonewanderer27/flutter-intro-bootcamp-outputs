import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_groceries/features/authentication/domain/datasources/auth_remote_firebase.dart';
import 'package:my_groceries/features/authentication/domain/entities/auth_user_entity.dart';

class AuthRemoteFirebaseImpl implements AuthRemoteFirebase {
  @override
  FirebaseAuth get auth => FirebaseAuth.instance;

  @override
  Stream<AuthUserEntity?> get user => auth.authStateChanges().map((user) {
    if (user == null) return null;
  });

  @override
  Future<AuthUserEntity> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    // TODO: implement signInWithEmailAndPassword

  }

  @override
  Future<AuthUserEntity> signUpWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
