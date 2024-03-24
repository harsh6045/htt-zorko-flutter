import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zorko/screens/home/recipe.dart';
import 'package:zorko/utils/app_styles.dart';
import 'package:zorko/utils/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

import 'comment_card.dart';
import 'dealswidget.dart';
import 'food_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = [
    "Offers",
    "Veg-items",
    "Combos",
    "No-garlic & no-onion",
    "Spicy",
  ];
  final List<Recipe> recipes = [
    Recipe(id: '1', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger'),
    Recipe(id: '2', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger'),
    Recipe(id: '3', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger'),
    Recipe(id: '4', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger'),
    Recipe(id: '5', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger'),
    Recipe(id: '6', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger'),
    Recipe(id: '7', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger'),
    Recipe(id: '8', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger'),
    // Add more Recipe instances as needed
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream = Stream<int>.periodic(const Duration(seconds: 1), (x) => refreshNum);

  ScrollController _scrollController = ScrollController();

  String uuid = const Uuid().v4(); // Generate a random UUID
  int current = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: LiquidPullToRefresh(
          backgroundColor: kBlue,
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: kPadding24,
                    ),
                    SizedBox(
                      height: 34,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                current = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? kPadding20 : 12,
                                right: index == categories.length - 1 ? kPadding20 : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: kPadding16,
                              ),
                              height: 34,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0,
                                    offset: const Offset(0, 18),
                                    blurRadius: 18,
                                    color: current == index ? kBlue.withOpacity(0.1) : kBlue.withOpacity(0),
                                  )
                                ],
                                gradient: current == index ? kLinearGradientBlue : kLinearGradientWhite,
                                borderRadius: BorderRadius.circular(
                                  kBorderRadius10,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  categories[index],
                                  style: kRalewayMedium.copyWith(
                                    color: current == index ? kWhite : kGrey85,
                                    fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: kPadding24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Deals of the Day....Grab it now.!",
                        style: kRalewayMedium.copyWith(
                          color: kBlack,
                          fontSize: SizeConfig.blockSizeHorizontal! * 4,
                        ),
                      ),
                    ),
                    DealsWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Items in City',
                            style: kRalewayMedium.copyWith(
                              color: kBlack,
                              fontSize: SizeConfig.blockSizeHorizontal! * 4,
                            ),
                          ),
                          Text(
                            'See more',
                            style: kRalewayRegular.copyWith(
                              color: kGrey85,
                              fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: kPadding24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top rated places',
                            style: kRalewayMedium.copyWith(
                              color: kBlack,
                              fontSize: SizeConfig.blockSizeHorizontal! * 4,
                            ),
                          ),
                          Text(
                            'See more',
                            style: kRalewayRegular.copyWith(
                              color: kGrey85,
                              fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                        return ReviewItem(
                          recipe: Recipe(
                            id: "1",
                            imageUrl: data['ProductImage'],
                            title: data['OrderItems'],
                          ),
                          onMenuSelect: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailPage(url: data['ProductImage']),));
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: kPadding24,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
