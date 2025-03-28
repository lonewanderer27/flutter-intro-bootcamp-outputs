import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/models/meal.dart';
import 'package:meals_coffee_lounge/widgets/meal_item/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.meals, this.title});
  final List<Meal> meals;
  final String? title;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Uh oh... Nothing is here', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(
            height: 10,
          ),
          Text(
            'Try selecting a different category.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
          )
        ],
      ),
    );

    if (meals.isNotEmpty) {
      content = ListView.builder(itemCount: meals.length, itemBuilder: (ctx, index) => MealItem(meal: meals[index]));
    }

    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Hero(
            tag: title!,
            child: Text(title!, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface))),
      ),
      body: content,
    );
  }
}
