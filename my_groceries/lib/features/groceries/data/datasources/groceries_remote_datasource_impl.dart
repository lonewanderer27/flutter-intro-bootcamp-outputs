import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_groceries/features/groceries/data/models/category_model.dart';
import 'package:my_groceries/features/groceries/data/models/grocery_item_model.dart';
import 'package:my_groceries/features/groceries/domain/datasources/groceries_remote_datasource.dart';

class GroceriesRemoteDatasourceImpl implements GroceriesRemoteDatasource {
  final FirebaseFirestore fs = FirebaseFirestore.instance;

  GroceriesRemoteDatasourceImpl();

  @override
  Future<List<GroceryItemModel>> getGroceries() async {
    // fetch the snapshot of the groceries list
    final snapshot = await fs.collection('grocery-items').get();
    // convert the list of snapshots into list of grocery_item_model
    return snapshot.docs
        .map((item) => GroceryItemModel.fromJson(item.data()))
        .toList();
  }

  @override
  Future<GroceryItemModel?> getGrocery(String id) async {
    final doc = await fs.collection('grocery-items').doc(id).get();
    if (!doc.exists) return null;
    return GroceryItemModel.fromJson(doc.data()!);
  }

  @override
  Future<void> addGrocery(
      String name, int quantity, CategoryModel category) async {
    return await fs
        .collection('grocery-items')
        .doc()
        .set({'name': name, 'quantity': quantity, 'categoryId': category.id});
  }

  @override
  Future<void> updateGrocery(
      String id, String name, int quantity, CategoryModel category) async {
    return await fs.collection('grocery-items').doc(id).set(GroceryItemModel(
            id: id, name: name, quantity: quantity, category: category)
        .toJson());
  }

  @override
  Future<void> deleteGrocery(String id) async {
    return await fs.collection('grocery-items').doc(id).delete();
  }
}
