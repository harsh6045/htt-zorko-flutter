import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zorko/screens/home/recipe.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key, required this.recipe, required this.onMenuSelect});
  final Recipe recipe; // Changed type to Recipe
  final void Function() onMenuSelect;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: onMenuSelect,
        child: Stack(
          children: [
            Hero(
              tag: recipe.id, // Use recipe.id
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage(recipe.imageUrl), // Use recipe.imageUrl
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white70,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 40,
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title, // Use recipe.title
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    Spacer(),
                    Text("Ratings 4.6 "),
                    Icon(Icons.star)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
