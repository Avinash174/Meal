import 'package:flutter/material.dart';
import 'package:meal_app/screens/tabs.dart';
import 'package:meal_app/widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _isGlutenFree = false;
  void _setGlutenFree(bool newValue) {
    setState(() {
      _isGlutenFree = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Filters')),
      drawer: MainDrawer(
        onSelectScreen: (idetifier) {
          // ✅ close drawer
          Navigator.of(context).pop();
          // No further action needed here
          if (idetifier == 'meals') {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => TabsScreen()));
          }
        },
      ),
      body: SwitchListTile(
        value: _isGlutenFree,
        onChanged: _setGlutenFree,
        title: Text(
          'Gluten-Free',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          'Only include gluten-free meals.',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        activeColor: Theme.of(context).colorScheme.tertiary,
        contentPadding: const EdgeInsets.only(left: 34, right: 22),
      ),
    );
  }
}
