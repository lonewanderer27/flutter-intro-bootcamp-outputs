import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  final Category category;
  final void Function(Category category) changeCategory;
  const CategoryGridItem({super.key, required this.category, required this.changeCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        changeCategory(category);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: Hero(
        tag: category.title,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: [category.color.withAlpha((255 * 0.55).round()), category.color.withAlpha((255 * 0.9).round())],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Text(
            category.title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
