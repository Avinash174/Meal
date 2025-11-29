import 'package:flutter/material.dart';
import 'package:meal_app/model/meal.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    required this.title,
    required this.meals,
    required this.selectMeal, // ✅ FIX: Added in constructor
  });

  final String title;
  final List<Meal> meals;
  final void Function(BuildContext, Meal) selectMeal;

  void onSelectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MealDetailsScreen(
          meal: meal,
        ), // ✅ FIX: Go to MealDetailsScreen, not MealItem
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No meals found! Try selecting different filters.',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Try selecting different meal.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return MealItem(
            meal: meals[index],
            onSelectMeal: (meal) => onSelectMeal(context, meal),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
    );
  }
}
