import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zorko/screens/home/comment_card2.dart';
import 'package:zorko/screens/home/post.dart';
import 'package:zorko/screens/home/recipe.dart';
import 'add_post.dart';
import 'comment_card.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Dummy data for recipes
  final List<Recipe> recipes = [
    Recipe(
        id: '1',
        imageUrl: 'assets/food/image1.jpg',
        title: 'Double Cheese burger'),
    Recipe(
        id: '2',
        imageUrl: 'assets/food/image2.jpg',
        title: 'Single Patty Burger'),
  ];

  // List to store the new posts
  List<Map<String, dynamic>> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: recipes.isEmpty
          ? Center(child: Text('No recipes yet.'))
          : ListView.builder(
        itemCount: recipes.length + posts.length,
        itemBuilder: (context, index) {
          if (index < recipes.length) {
            return ReviewItem2(
              recipe: recipes[index],
              onMenuSelect: () {
                // Handle menu selection action (optional)
              },
            );
          } else {
            // Display the new posts with enhanced UI including name heading and reduced vertical gap
            final postIndex = index - recipes.length;
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(posts[postIndex]['name'] ?? 'Anonymous', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white70)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0), // Reduced vertical padding
                    child: ListTile(
                      leading: Icon(Icons.comment, color: Colors.blue),
                      title: Text(posts[postIndex]['comment'] ?? 'No comment'),
                      subtitle: Text('Rating: ${posts[postIndex]['rating'] ?? 'No rating'}'),
                      trailing: Icon(Icons.star, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostPage()),
          );

          if (result != null) {
            setState(() {
              posts.add(result);
            });
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
