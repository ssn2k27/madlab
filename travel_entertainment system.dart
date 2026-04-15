import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel & Entertainment',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TravelCalculator(),
    MovieRatingPage(),
    SwipePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Travel & Entertainment")),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: "Travel"),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.swipe), label: "Swipe"),
        ],
      ),
    );
  }
}

////////////////////////////////////////////
/// TRAVEL COST CALCULATOR
////////////////////////////////////////////

class TravelCalculator extends StatefulWidget {
  @override
  _TravelCalculatorState createState() => _TravelCalculatorState();
}

class _TravelCalculatorState extends State<TravelCalculator> {
  final distanceController = TextEditingController();
  final costPerKmController = TextEditingController();
  double totalCost = 0;

  void calculateCost() {
    double distance = double.tryParse(distanceController.text) ?? 0;
    double cost = double.tryParse(costPerKmController.text) ?? 0;

    setState(() {
      totalCost = distance * cost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: distanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Distance (km)"),
          ),
          TextField(
            controller: costPerKmController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Cost per km"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: calculateCost,
            child: Text("Calculate"),
          ),
          SizedBox(height: 20),
          Text("Total Cost: ₹$totalCost",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

////////////////////////////////////////////
/// MOVIE RATING SYSTEM
////////////////////////////////////////////

class MovieRatingPage extends StatefulWidget {
  @override
  _MovieRatingPageState createState() => _MovieRatingPageState();
}

class _MovieRatingPageState extends State<MovieRatingPage> {
  List<Map<String, dynamic>> movies = [
    {"name": "Inception", "rating": 3.0},
    {"name": "Interstellar", "rating": 4.0},
    {"name": "Avengers", "rating": 2.5},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(movies[index]['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: movies[index]['rating'],
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: movies[index]['rating'].toString(),
                  onChanged: (value) {
                    setState(() {
                      movies[index]['rating'] = value;
                    });
                  },
                ),
                Text("Rating: ${movies[index]['rating']} ⭐"),
              ],
            ),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////
/// SWIPE PAGE
////////////////////////////////////////////

class SwipePage extends StatelessWidget {
  final List<Map<String, String>> items = [
    {"title": "Goa Trip", "desc": "Beach vibes 🌊"},
    {"title": "Movie Night", "desc": "Watch latest films 🎬"},
    {"title": "Hill Station", "desc": "Cool climate 🌄"},
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: items.length,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(items[index]['title']!,
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(items[index]['desc']!,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}