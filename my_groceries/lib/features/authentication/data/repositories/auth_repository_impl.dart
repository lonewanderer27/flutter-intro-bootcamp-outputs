import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_groceries/features/authentication/data/datasources/auth_remote_firebase_impl.dart';
import 'package:my_groceries/features/authentication/data/models/auth_user_model.dart';
import 'package:my_groceries/features/authentication/domain/entities/auth_exception_entity.dart';
import 'package:my_groceries/features/authentication/domain/repositories/auth_repository.dart';

AuthException mapFirebaseAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'invalid-email':
      return InvalidEmailException(error.message);
    case 'user-disabled':
      return UserDisabledException(error.message);
    case 'user-not-found':
      return UserNotFoundException(error.message);
    case 'wrong-password':
      return WrongPasswordException(error.message);
    case 'too-many-requests':
      return TooManyRequestsException(error.message);
    case 'user-token-expired':
      return UserTokenExpiredException(error.message);
    case 'network-request-failed':
      return NetworkRequestFailedException(error.message);
    case 'invalid-credential':
    case 'INVALID_LOGIN_CREDENTIALS':
      return InvalidLoginCredentialsException(error.message);
    case 'operation-not-allowed':
      return OperationNotAllowedException(error.message);
    case 'email-already-in-use':
      return EmailAlreadyInUseException(error.message);
    case 'weak-password':
      return WeakPasswordException(error.message);
    case 'requires-recent-login':
      return RequiresRecentLoginException(error.message);
    case 'account-exists-with-different-credential':
      return AccountExistsWithDifferentCredentialException(error.message);
    case 'invalid-action-code':
      return InvalidActionCodeException(error.message);
    case 'captcha-check-failed':
      return CaptchaCheckFailedException(error.message);
    case 'user-mismatch':
      return UserMismatchException(error.message);
    case 'invalid-persistence-type':
      return InvalidPersistenceException(error.message);
    default:
      return UnknownAuthException('${error.code}: ${error.message}');
  }
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteFirebaseImpl datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Either<Exception, Stream<AuthUserModel?>> user() {
    try {
      return Right(datasource.user);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<AuthException, AuthUserModel>> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return Right(await datasource.signUpWithEmailAndPassword(
          email: email, password: password));
    } on FirebaseAuthException catch (error) {
      return Left(mapFirebaseAuthError(error));
    } catch (e) {
      return Left(UnknownAuthException());
    }
  }

  @override
  Future<Either<AuthException, AuthUserModel>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return Right(await datasource.signInWithEmailAndPassword(
          email: email, password: password));
    } on FirebaseAuthException catch (error) {
      return Left(mapFirebaseAuthError(error));
    } catch (e) {
      return Left(UnknownAuthException());
    }
  }

  @override
  Future<Either<AuthException, void>> signOut() async {
    try {
      return Right(await datasource.signOut());
    } catch (e) {
      return Left(UnknownAuthException());
    }
  }
}
