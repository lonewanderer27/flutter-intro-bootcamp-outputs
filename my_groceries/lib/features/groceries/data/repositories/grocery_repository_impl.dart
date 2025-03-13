import 'package:either_dart/either.dart';
import 'package:my_groceries/features/groceries/data/datasources/groceries_remote_datasource_impl.dart';
import 'package:my_groceries/features/groceries/data/models/category_model.dart';
import 'package:my_groceries/features/groceries/data/models/grocery_item_model.dart';
import 'package:my_groceries/features/groceries/domain/repositories/grocery_repository.dart';

class GroceryRepositoryImpl implements GroceryRepository {
  final GroceriesRemoteDatasourceImpl datasource;

  GroceryRepositoryImpl(this.datasource);

  @override
  Either<Exception, Stream<List<GroceryItemModel>>> watchGroceries() {
    try {
      return Right(datasource.watchGroceries());
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, List<GroceryItemModel>>> getGroceries() async {
    try {
      return Right(await datasource.getGroceries());
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, GroceryItemModel?>> getGrocery(String id) async {
    try {
      return Right(await datasource.getGrocery(id));
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, void>> addGrocery(
      String name, CategoryModel category, int quantity) async {
    try {
      return Right(await datasource.addGrocery(name, quantity, category));
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, void>> updateGrocery(
      String id, String name, CategoryModel category, int quantity) async {
    try {
      return Right(
          await datasource.updateGrocery(id, name, quantity, category));
    } catch (error) {
      return Left(Exception(error));
    }
  }
}
