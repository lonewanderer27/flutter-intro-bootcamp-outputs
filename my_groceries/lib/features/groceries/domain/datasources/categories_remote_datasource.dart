import 'package:my_groceries/features/groceries/domain/entities/category_entity.dart';

abstract class CategoriesRemoteDatasource {
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryEntity?> getCategory(String id);
}
