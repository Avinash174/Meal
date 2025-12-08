import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/provider/filters_provider.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  late bool _isGlutenFree;
  late bool _isLactoseFree;
  late bool _isVegan;
  late bool _isVegetarian;
  late bool _isSugarFree;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(filtersProvider);
    _isGlutenFree = currentFilters[Filter.glutenFree] ?? false;
    _isLactoseFree = currentFilters[Filter.lactoseFree] ?? false;
    _isVegan = currentFilters[Filter.vegan] ?? false;
    _isVegetarian = currentFilters[Filter.vegetarian] ?? false;
    _isSugarFree = currentFilters[Filter.sugarFree] ?? false;
  }

  void _saveAndPop() {
    ref.read(filtersProvider.notifier).setFilters({
      Filter.glutenFree: _isGlutenFree,
      Filter.lactoseFree: _isLactoseFree,
      Filter.vegan: _isVegan,
      Filter.vegetarian: _isVegetarian,
      Filter.sugarFree: _isSugarFree,
    });

    Navigator.of(context).pop(); // ✅ go back after saving
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    void Function(bool) onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ build signature must NOT have WidgetRef here
    return WillPopScope(
      onWillPop: () async {
        _saveAndPop(); // auto-save on system back
        return false; // prevent default pop, we already popped
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Filters'),
          actions: [
            IconButton(onPressed: _saveAndPop, icon: const Icon(Icons.save)),
          ],
        ),
        body: ListView(
          children: [
            _buildSwitchTile(
              'Gluten-Free',
              'Only include gluten-free meals.',
              _isGlutenFree,
              (isChecked) => setState(() => _isGlutenFree = isChecked),
            ),
            _buildSwitchTile(
              'Lactose-Free',
              'Only include lactose-free meals.',
              _isLactoseFree,
              (isChecked) => setState(() => _isLactoseFree = isChecked),
            ),
            _buildSwitchTile(
              'Vegan',
              'Only include vegan meals.',
              _isVegan,
              (isChecked) => setState(() => _isVegan = isChecked),
            ),
            _buildSwitchTile(
              'Vegetarian',
              'Only include vegetarian meals.',
              _isVegetarian,
              (isChecked) => setState(() => _isVegetarian = isChecked),
            ),
            _buildSwitchTile(
              'Sugar-Free',
              'Only include sugar-free meals.',
              _isSugarFree,
              (isChecked) => setState(() => _isSugarFree = isChecked),
            ),
          ],
        ),
      ),
    );
  }
}
