import 'package:my_groceries/features/groceries/domain/entities/category_entity.dart';
import 'package:my_groceries/features/groceries/domain/entities/grocery_item_entity.dart';

abstract class GroceriesRemoteDatasource {
  Stream<List<GroceryItemEntity>> watchGroceries();
  Future<List<GroceryItemEntity>> getGroceries();
  Future<GroceryItemEntity?> getGrocery(String id);
  Future<void> addGrocery(
      String name, int quantity, covariant CategoryEntity category);
  Future<void> deleteGrocery(String id);
  Future<void> updateGrocery(
      String id, String name, int quantity, covariant CategoryEntity category);
}
