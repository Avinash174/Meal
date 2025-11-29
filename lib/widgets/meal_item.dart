import 'package:flutter/material.dart';
import 'package:meal_app/model/meal.dart';
import 'package:meal_app/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal});

  final Meal meal;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordability {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    // quick debug - remove after verifying
    // print('Building meal: ${meal.title}');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge, // important to clip image to rounded corners
      child: InkWell(
        onTap: () {
          // Handle meal item tap
        },
        child: Column(
          // Use Column so the card has intrinsic height from the image
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Constrain image height so it is visible
            SizedBox(
              height: 200,
              width: double.infinity,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover, // fill the box
                fadeInDuration: const Duration(milliseconds: 250),
                imageErrorBuilder: (context, error, stackTrace) {
                  // Show fallback if network image fails
                  return Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.05),
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 48),
                  );
                },
              ),
            ),

            // Title / metadata area
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    meal.title,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MealItemTrait(
                        icon: Icons.schedule,
                        label: '${meal.duration} min  ',
                      ),
                      SizedBox(width: 12),
                      MealItemTrait(icon: Icons.work, label: complexityText),
                      SizedBox(width: 12),
                      MealItemTrait(
                        icon: Icons.attach_money,
                        label: affordability,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
