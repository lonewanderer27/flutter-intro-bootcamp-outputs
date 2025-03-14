abstract class AuthUserEntity {
  final String id;
  final String email;
  final String? photoUrl;

  const AuthUserEntity({required this.id, required this.email, this.photoUrl});
}
