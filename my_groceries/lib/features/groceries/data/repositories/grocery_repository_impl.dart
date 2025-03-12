import 'package:either_dart/either.dart';
import 'package:my_groceries/features/groceries/data/datasources/groceries_remote_datasource_impl.dart';
import 'package:my_groceries/features/groceries/data/models/category_model.dart';
import 'package:my_groceries/features/groceries/data/models/grocery_item_model.dart';
import 'package:my_groceries/features/groceries/domain/entities/grocery_item_entity.dart';
import 'package:my_groceries/features/groceries/domain/repositories/grocery_repository.dart';

class GroceryRepositoryImpl implements GroceryRepository {
  final GroceriesRemoteDatasourceImpl ds = GroceriesRemoteDatasourceImpl();

  GroceryRepositoryImpl();

  @override
  Future<Either<Exception, List<GroceryItemEntity>>> getGroceries() async {
    try {
      return Right(await ds.getGroceries());
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, GroceryItemModel?>> getGrocery(String id) async {
    try {
      return Right(await ds.getGrocery(id));
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, void>> addGrocery(
      String name, CategoryModel category, int quantity) async {
    try {
      return Right(await ds.addGrocery(name, quantity, category));
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, void>> updateGrocery(
      String id, String name, CategoryModel category, int quantity) async {
    try {
      return Right(await ds.updateGrocery(id, name, quantity, category));
    } catch (error) {
      return Left(Exception(error));
    }
  }
}
