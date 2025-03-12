import 'package:json_annotation/json_annotation.dart';
import 'package:my_groceries/features/groceries/data/models/category_model.dart';
import 'package:my_groceries/features/groceries/domain/entities/grocery_item_entity.dart';

part 'grocery_item_model.g.dart';

@JsonSerializable()
class GroceryItemModel implements GroceryItemEntity {
  @override
  final String id;

  @override
  final String name;

  @override
  final int quantity;

  @override
  @JsonKey(name: 'category')
  final CategoryModel category;

  const GroceryItemModel(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) =>
      _$GroceryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroceryItemModelToJson(this);

  GroceryItemEntity toEntity() => GroceryItemEntity(
      id: id, name: name, quantity: quantity, category: category);
}
