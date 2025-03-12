import 'package:either_dart/either.dart';
import 'package:my_groceries/features/groceries/data/models/category_model.dart';
import 'package:my_groceries/features/groceries/domain/entities/category_entity.dart';
import 'package:my_groceries/features/groceries/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<Either<Exception, CategoryModel>> getCategory(String id) {
    // TODO: implement getCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, List<CategoryModel>>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }
}
