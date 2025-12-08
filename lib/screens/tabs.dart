// lib/screens/tabs.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/model/meal.dart';
import 'package:meal_app/provider/favorite_provider.dart';
import 'package:meal_app/provider/filters_provider.dart';
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

  // ---------- Helpers ----------

  bool _isMealFavourite(Meal meal) {
    final favoriteMeals = ref.watch(favouriteProvider);
    return favoriteMeals.contains(meal);
  }

  String get _activePageTitle {
    return _selectedPageIndex == 0 ? 'Categories' : 'Favorites';
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Drawer navigation
  void _setScreen(String identifier) async {
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (ctx) => FiltersScreen()),
      );

      if (result == null) return;

      ref.read(filtersProvider.notifier).state = result;
    } else if (identifier == 'meals') {
      setState(() {
        _selectedPageIndex = 0;
      });
    }
  }

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    // Apply filters
    final _activeFilters = ref.watch(filtersProvider);
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
      // If you want to actually use sugarFree, add a property in Meal
      // and check it here like the others.
      return true;
    }).toList();

    late Widget activePageWidget;

    if (_selectedPageIndex == 0) {
      // Categories tab
      activePageWidget = CategoriesScreen(
        availableMeals: availableMeals,
        toggleFavourite: (meal) {
          ref.read(favouriteProvider.notifier).toggleMeal(meal);
        },
        isMealFavourite: _isMealFavourite,
      );
    } else {
      // Favorites tab
      final favoriteMeals = ref.watch(favouriteProvider);

      activePageWidget = MealsScreen(
        title: 'Your Favorites',
        meals: favoriteMeals,
        selectMeal: (ctx, meal) {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (_) => MealDetailsScreen(
                meal: meal,
                toggleFavourite: (meal) {
                  ref.read(favouriteProvider.notifier).toggleMeal(meal);
                },
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
