import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_groceries/features/groceries/data/models/category_model.dart';
import 'package:my_groceries/features/groceries/domain/datasources/categories_remote_datasource.dart';

class CategoriesRemoteDatasourceImpl implements CategoriesRemoteDatasource {
  final FirebaseFirestore firestore;

  CategoriesRemoteDatasourceImpl(this.firestore);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await firestore.collection('categories').get();
    return snapshot.docs
        .map((item) => CategoryModel.fromJson(item.data()))
        .toList();
  }

  @override
  Future<CategoryModel> getCategory(String id) async {
    final doc = await firestore.collection('categories').doc(id).get();
    return CategoryModel.fromJson(doc.data()!);
  }
}
