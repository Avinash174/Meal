import 'package:flutter/material.dart';
import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/model/category.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/widgets/categories_grid.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals.where((meal) {
      return meal.categories.contains(category.id);
    }).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MealsScreen(
          title: category.name,
          meals: filteredMeals,
          selectMeal: (ctx, meal) {
            Navigator.of(ctx).push(
              MaterialPageRoute(builder: (_) => MealDetailsScreen(meal: meal)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategory) // <-- correct name
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          ),
      ],
    );
  }
}
