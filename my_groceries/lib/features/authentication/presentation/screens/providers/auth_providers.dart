import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/features/authentication/data/datasources/auth_remote_firebase_impl.dart';
import 'package:my_groceries/features/authentication/data/models/auth_user_model.dart';
import 'package:my_groceries/features/authentication/data/repositories/auth_repository_impl.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteFirebaseImpl>((ref) {
  final auth = FirebaseAuth.instance;
  return AuthRemoteFirebaseImpl(auth);
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

final userStreamProvider = StreamProvider<AuthUserModel>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final res = repo.user;
  return res.fold((error) => Stream.error(error), (stream) => stream);
});