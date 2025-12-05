import 'package:flutter/material.dart';
import 'package:meal_app/model/meal.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  void _showInfoMsg(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealsFavourite(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    setState(() {
      if (isExisting) {
        _favoriteMeals.remove(meal);
        _showInfoMsg(context, 'Meal removed from favorites.');
      } else {
        _favoriteMeals.add(meal);
        _showInfoMsg(context, 'Meal added to favorites.');
      }
    });
  }

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

  void _setScreen(String identifier) {
    if (identifier == 'filters') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
      );
    } else if (identifier == 'meals') {
      setState(() {
        _selectedPageIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePageWidget;

    if (_selectedPageIndex == 0) {
      activePageWidget = CategoriesScreen(
        toggleFavourite: _toggleMealsFavourite,
        isMealFavourite: _isMealFavourite,
      );
    } else {
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
      drawer: MainDrawer(onSelectScreen: _setScreen),

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
