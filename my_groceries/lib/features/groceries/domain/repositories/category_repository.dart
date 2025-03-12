import 'package:either_dart/either.dart';
import 'package:my_groceries/features/groceries/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Exception, CategoryEntity>> getCategory(String id);
  Future<Either<Exception, List<CategoryEntity>>> getCategories();
}
