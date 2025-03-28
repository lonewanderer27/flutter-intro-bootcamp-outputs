import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_coffee_lounge/constants/k_initial_filters.dart';
import 'package:meals_coffee_lounge/data/meals.dart';
import 'package:meals_coffee_lounge/enums/filter.dart';

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  // this looks confusing at first
  // but using super instantiates the default value of this notifier
  // in this case, we set to the initial default filters
  // which will be populated with the filters in the future
  FiltersNotifier() : super(kInitialFilters);

  void setFilter(Filter filter, bool value) {
    state = {...state, filter: value};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

final filteredMealsProvider = Provider((ref) {
  final activeFilters = ref.watch(filtersProvider);
  return availableMeals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) return false;
    if (activeFilters[Filter.vegetarianFree]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) return false;
    return true;
  }).toList();
});
