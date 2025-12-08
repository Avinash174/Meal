import 'package:flutter_riverpod/legacy.dart';
import 'package:meal_app/model/meal.dart';

class FavouriteNotifier extends StateNotifier<List<Meal>> {
  FavouriteNotifier() : super([]);

  bool toggleMeal(Meal meal) {
    final isExisting = state.contains(meal);

    if (isExisting) {
      // remove meal
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      // add meal
      state = [...state, meal];
      return true;
    }
  }
}

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, List<Meal>>(
  (ref) => FavouriteNotifier(),
);
