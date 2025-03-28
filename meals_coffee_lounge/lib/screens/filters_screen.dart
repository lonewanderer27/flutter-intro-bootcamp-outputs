import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_coffee_lounge/providers/filters_provider.dart';
import 'package:meals_coffee_lounge/screens/tabs_screen.dart';
import 'package:meals_coffee_lounge/widgets/main_drawer.dart';
import 'package:meals_coffee_lounge/enums/filter.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your filters'),
      ),
      drawer: MainDrawer(onSelectScreen: (String identifier) {
        Navigator.of(context).pop();

        switch (identifier) {
          case 'filters':
            {
              // Navigator.of(context).pop();
            }
            break;
          case 'meals':
            {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
            }
        }
      }),
      body: Column(
        children: [
          SwitchListTile(
            value: activeFilters[Filter.lactoseFree]!,
            onChanged: (val) {
              ref.read(filtersProvider.notifier).setFilter(Filter.lactoseFree, val);
            },
            title: Text('Lactose-free', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Only include lactose-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.glutenFree]!,
            onChanged: (val) {
              // set the global gluten free filter
              ref.read(filtersProvider.notifier).setFilter(Filter.glutenFree, val);
            },
            title: Text(
              'Gluten-free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            subtitle: Text('Only include gluten-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.vegetarianFree]!,
            onChanged: (val) {
              // set the global vegetarian filter
              ref.read(filtersProvider.notifier).setFilter(Filter.vegetarianFree, val);
            },
            title: Text('Vegetarian', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Only include vegetarian meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.vegan]!,
            onChanged: (val) {
              // set the global vegan filter
              ref.read(filtersProvider.notifier).setFilter(Filter.vegan, val);
            },
            title: Text('Vegan', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Only include vegan meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          )
        ],
      ),
    );
  }
}
