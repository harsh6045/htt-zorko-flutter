import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodDetailPage extends ConsumerWidget {
  const FoodDetailPage({
    super.key,
    required this.url,
  });

  final String url; // Declare the URL as a final String

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double rating = 3.5;
    bool isplaying = false;
    bool audioplayed = false;
    int getTextValue(double rating) {
      if (rating == 1) {
        return 1;
      } else if (rating == 2) {
        return 2;
      } else if (rating == 3) {
        return 3;
      } else if (rating == 4) {
        return 4;
      } else if (rating == 5) {
        return 5;
      } else {
        return 0;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Detail",
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(
                    begin: 0.8,
                    end: 1,
                  ).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                Icons.star,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      url,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              ],
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Chessy Burger",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // Replace with the actual initial rating value
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 25,
                          itemBuilder: (context, index) {
                            IconData starIcon = Icons.star;
                            Color starColor;

                            if (rating >= 1) {
                              if (rating <= 2) {
                                starColor = Colors.red;
                              } else if (rating <= 3) {
                                starColor = Colors.orange;
                              } else if (rating <= 4) {
                                starColor = Colors.yellow;
                              } else {
                                starColor = Colors.green;
                              }
                            } else {
                              starColor = Colors.grey;
                            }

                            return Icon(starIcon, color: starColor);
                          },
                          onRatingUpdate: (newRating) {

                          },
                        ),


                        SizedBox(width: 5),
                        Text("(${getTextValue(rating)})"),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 230, top: 10),
                      child: Text(
                        "Rs.72/- only",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 100,),
                      ],
                    ),
                    const Text(
                      "This burger is not just a meal; it's an experience. It's a testament to the art of cooking, where every ingredient is chosen with care and every bite is crafted with passion. It's a culinary journey that promises to delight and satisfy, making it a must-try for anyone seeking a truly memorable dining experience.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 5),
                      child: Row(
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orangeAccent,
                              ),
                              child: Icon(Icons.remove, size: 20),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text("2"),
                          SizedBox(width: 10,),

                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orangeAccent,
                              ),
                              child: Icon(Icons.add, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                                   showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content:
                                    const Text("Add this to cart ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(
                                            msg: "Added to Cart",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.green,
                                          );

                                        },
                                        child: const Text("Yes"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("No"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 65,
                              width: 250,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Row(
                                children: [
                                     Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            height: 65,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFD4ECF7),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: InkWell(
                              onTap: () {
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 23,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
