import 'package:flutter_riverpod/legacy.dart';
import 'package:meal_app/model/meal.dart';

class FavouriteNotifier extends StateNotifier<List<int>> {
  FavouriteNotifier() : super([]);

  void toggleFavorite(Meal meal) {
    final mealId = int.parse(meal.id);

    if (state.contains(mealId)) {
      state = state.where((id) => id != mealId).toList();
    } else {
      state = [...state, mealId];
    }
  }
}

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, List<int>>(
  (ref) => FavouriteNotifier(),
);
