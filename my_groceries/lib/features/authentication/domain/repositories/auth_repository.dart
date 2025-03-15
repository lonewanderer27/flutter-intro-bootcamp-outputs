import 'package:either_dart/either.dart';
import 'package:my_groceries/features/authentication/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Either<Exception, Stream<AuthUserEntity?>> user();

  Future<Either<Exception, AuthUserEntity>> signInWithEmailAndPassword(
      String email, String password);

  Future<Either<Exception, AuthUserEntity>> createUserWithEmailAndPassword(
      String email, String password);

  Future<void> signOut();
}
