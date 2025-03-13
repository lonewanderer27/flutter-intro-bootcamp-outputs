import 'package:my_groceries/features/groceries/domain/entities/category_entity.dart';
import 'package:my_groceries/features/groceries/domain/entities/grocery_item_entity.dart';
import 'package:either_dart/either.dart';

abstract class GroceryRepository {
  Either<Exception, Stream<List<GroceryItemEntity>>> watchGroceries();
  Future<Either<Exception, GroceryItemEntity?>> getGrocery(String id);

  Future<Either<Exception, List<GroceryItemEntity>>> getGroceries();

  Future<Either<Exception, void>> addGrocery(
      String name, covariant CategoryEntity category, int quantity);

  Future<Either<Exception, void>> updateGrocery(
      String id, String name, covariant CategoryEntity category, int quantity);
}
