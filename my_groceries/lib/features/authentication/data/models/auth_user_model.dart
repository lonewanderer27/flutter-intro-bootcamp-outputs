import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_groceries/features/authentication/domain/entities/auth_user_entity.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel implements AuthUserEntity {
  @override
  final String id;

  @override
  final String? email;

  @override
  final String? name;

  @override
  final String? photoUrl;

  const AuthUserModel(
      {required this.id, required this.email, this.name, this.photoUrl});

  factory AuthUserModel.fromFirebaseAuthUser(User firebaseUser) {
    return AuthUserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL);
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUserEntity toEntity() =>
      AuthUserEntity(id: id, email: email, name: name, photoUrl: photoUrl);
}
