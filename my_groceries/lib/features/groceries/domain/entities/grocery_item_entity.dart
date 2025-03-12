import 'package:my_groceries/features/groceries/domain/entities/category_entity.dart';

class GroceryItemEntity {
  final String id;
  final String name;
  final int quantity;
  final CategoryEntity category;

  const GroceryItemEntity(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});
}
