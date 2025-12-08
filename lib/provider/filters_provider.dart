// lib/provider/filters_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum Filter { glutenFree, lactoseFree, vegan, vegetarian, sugarFree }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegan: false,
        Filter.vegetarian: false,
        Filter.sugarFree: false,
      });

  void setFilters(Map<Filter, bool> updatedFilters) {
    state = updatedFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
      (ref) => FiltersNotifier(),
    );

final filterMealProvider = Provider<Map<Filter, bool>>((ref) {
  return ref.watch(filtersProvider);
});


