import 'package:flutter/material.dart';
import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/model/meal.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/screens/meals.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  // Toggle favourite state for a meal
  void _toggleMealsFavourite(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    setState(() {
      if (isExisting) {
        _favoriteMeals.remove(meal);
      } else {
        _favoriteMeals.add(meal);
      }
    });
  }

  // Helper to check if a meal is favourite
  bool _isMealFavourite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  String get _activePageTitle {
    return _selectedPageIndex == 0 ? 'Categories' : 'Favorites';
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePageWidget;

    if (_selectedPageIndex == 0) {
      // Categories page — pass callbacks so it can open Meals -> MealDetails correctly
      activePageWidget = CategoriesScreen(
        toggleFavourite: _toggleMealsFavourite,
        isMealFavourite: _isMealFavourite,
      );
    } else {
      // Favorites page — show MealsScreen with only favorite meals
      activePageWidget = MealsScreen(
        title: 'Your Favorites',
        meals: _favoriteMeals,
        selectMeal: (ctx, meal) {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (_) => MealDetailsScreen(
                meal: meal,
                toggleFavourite: _toggleMealsFavourite,
                isFavourite: _isMealFavourite(meal),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_activePageTitle)),
      body: activePageWidget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
