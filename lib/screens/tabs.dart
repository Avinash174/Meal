import 'package:flutter/material.dart';
import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/meals.dart';

class TabsScree extends StatefulWidget {
  const TabsScree({super.key});

  @override
  State<TabsScree> createState() => _TabsScreeState();
}

class _TabsScreeState extends State<TabsScree> {
  int _selectedPageIndex = 0;

  var activePageTitle = 'Categories';

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget actvepage = CategoriesScreen();
    if (_selectedPageIndex == 1) {
      actvepage = MealsScreen(meals: [], selectMeal: (ctx, meal) {});
    }
    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      body: actvepage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: [
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
