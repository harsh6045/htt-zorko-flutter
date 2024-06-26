import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DealsWidget extends StatefulWidget {
  @override
  _DealsWidgetState createState() => _DealsWidgetState();
}

class _DealsWidgetState extends State<DealsWidget> {
  int _currentIndex = 0;
  final List<String> imgList = [
    'assets/deals/deal1.jpg',
    'assets/deals/deal2.jpg',
    'assets/deals/deal3.jpg',
    'assets/deals/deal4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CarouselSlider(
              items: imgList.map((item) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Center(
                  child: Image.asset(item, fit: BoxFit.cover, width: 1000,
                  ),
                ),
              )).toList(),
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
