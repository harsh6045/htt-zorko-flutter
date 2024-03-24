import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zorko/screens/home/filter.dart';
import 'package:zorko/screens/home/filter_card.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<Filter> filters = [
    Filter(id: '1', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger', price: 150),
    Filter(id: '2', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger', price: 160),
    Filter(id: '3', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger', price: 140),
    Filter(id: '4', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger', price: 130),
    Filter(id: '5', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger', price: 120),
    Filter(id: '6', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger', price: 135),
    Filter(id: '7', imageUrl: 'assets/food/image1.jpg', title: 'Double Cheese Burger', price: 145),
    Filter(id: '8', imageUrl: 'assets/food/image2.jpg', title: 'Single Patty Burger', price: 143),
  ];

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<Filter> applyFilter() {
    final enteredValue = int.tryParse(textEditingController.text) ?? 0;
    final filteredData = filters.where((filter) => filter.price < enteredValue).toList();
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter filter',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final filteredData = applyFilter();
                if (filteredData.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filtered values:\n${filteredData.map((filter) => filter.title).join("\n")}'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                  setState(() {
                    filters.clear();
                    filters.addAll(filteredData);
                  });
                }
              },
              child: Text('Apply Filter'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return FilterCard(
                    filter: filters[index],
                    onMenuSelect: () {
                      // Handle menu selection action (optional)
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
