import 'package:either_dart/either.dart';
import 'package:my_groceries/features/groceries/data/datasources/categories_remote_datasource_impl.dart';
import 'package:my_groceries/features/groceries/data/models/category_model.dart';
import 'package:my_groceries/features/groceries/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoriesRemoteDatasourceImpl datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Exception, CategoryModel>> getCategory(String id) async {
    try {
      return Right(await datasource.getCategory(id));
    } catch (error) {
      return Left(Exception(error));
    }
  }

  @override
  Future<Either<Exception, List<CategoryModel>>> getCategories() async {
    try {
      return Right(await datasource.getCategories());
    } catch (error) {
      return Left(Exception(error));
    }
  }
}
