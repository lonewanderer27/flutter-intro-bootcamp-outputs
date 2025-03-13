import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_groceries/features/groceries/data/datasources/groceries_remote_datasource_impl.dart';
import 'package:my_groceries/features/groceries/data/models/grocery_item_model.dart';
import 'package:my_groceries/features/groceries/data/repositories/grocery_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final groceriesRemoteDatasourceProvider =
    Provider<GroceriesRemoteDatasourceImpl>((ref) {
  final firestore = FirebaseFirestore.instance;
  return GroceriesRemoteDatasourceImpl(firestore);
});

final groceryRepositoryProvider = Provider<GroceryRepositoryImpl>((ref) {
  final datasource = ref.watch(groceriesRemoteDatasourceProvider);
  return GroceryRepositoryImpl(datasource);
});

final groceryStreamProvider = StreamProvider<List<GroceryItemModel>>((ref) {
  final repo = ref.watch(groceryRepositoryProvider);
  final res = repo.watchGroceries();
  return res.fold((error) => Stream.error(error), (stream) => stream);
});
