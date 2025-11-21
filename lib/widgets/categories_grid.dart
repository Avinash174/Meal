import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meal_app/model/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({super.key, required this.category, required Null Function() onSelectCategory});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => log('Category ${category.name} tapped!'),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [category.color.withOpacity(0.7), category.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          category.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
