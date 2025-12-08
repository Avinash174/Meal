import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/model/meal.dart';
import 'package:meal_app/provider/meals_provider.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  Map<Filter, bool> _activeFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false,
    Filter.sugarFree: false,
  };

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

  void _setScreen(String identifier) async {
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(currentFilters: _activeFilters),
        ),
      );

      if (result == null) return;

      setState(() {
        _activeFilters = result;
      });
    } else if (identifier == 'meals') {
      setState(() {
        _selectedPageIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    // ✅ Filter meals based on active filters
    final availableMeals = meals.where((meal) {
      if (_activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_activeFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    late Widget activePageWidget;

    if (_selectedPageIndex == 0) {
      activePageWidget = CategoriesScreen(
        availableMeals: availableMeals,
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
