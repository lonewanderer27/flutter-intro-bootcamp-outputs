import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_groceries/features/authentication/data/models/auth_user_model.dart';
import 'package:my_groceries/features/authentication/domain/datasources/auth_remote_firebase.dart';

class AuthRemoteFirebaseImpl implements AuthRemoteFirebase {
  final FirebaseAuth auth;

  AuthRemoteFirebaseImpl(this.auth);

  @override
  Stream<AuthUserModel?> get user => auth.authStateChanges().map((user) {
        if (user == null) return null;
        return AuthUserModel.fromFirebaseAuthUser(user);
      });

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    var credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return AuthUserModel.fromFirebaseAuthUser(credential.user!);
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    var credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return AuthUserModel.fromFirebaseAuthUser(credential.user!);
  }

  @override
  Future<void> signOut() {
    return auth.signOut();
  }
}
