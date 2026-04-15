import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodScreen(),
    );
  }
}

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String status = "Preparing 🍳";
  bool showMap = false;

  List<String> statusList = [
    "Preparing 🍳",
    "Out for Delivery 🚴",
    "Nearby 📍",
    "Delivered ✅"
  ];

  int statusIndex = 0;

  double startX = 0;

  void reorder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order Placed Again! 🔁")),
    );
  }

  void nextStatus() {
    setState(() {
      statusIndex = (statusIndex + 1) % statusList.length;
      status = statusList[statusIndex];
    });
  }

  void prevStatus() {
    setState(() {
      statusIndex =
          (statusIndex - 1 + statusList.length) % statusList.length;
      status = statusList[statusIndex];
    });
  }

  void toggleMap(bool value) {
    setState(() {
      showMap = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: Text("Food Delivery"),
        backgroundColor: Colors.deepOrange,
      ),

      // 👇 FULL SCREEN gesture detection
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // 🔥 important for edge swipe

        onDoubleTap: reorder,

        onLongPress: () => toggleMap(true),
        onLongPressUp: () => toggleMap(false),

        onHorizontalDragStart: (details) {
          startX = details.globalPosition.dx;
        },

        onHorizontalDragEnd: (details) {
          double endX = details.globalPosition.dx;
          double diff = endX - startX;

          if (diff > 80) {
            prevStatus(); // swipe right
          } else if (diff < -80) {
            nextStatus(); // swipe left
          }
        },

        child: Center(
          child: showMap
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 120, color: Colors.white),
              SizedBox(height: 10),
              Text(
                "Live Map View 📍",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fastfood,
                  size: 100, color: Colors.white),

              SizedBox(height: 20),

              Text(
                "Burger Meal 🍔",
                style:
                TextStyle(fontSize: 28, color: Colors.white),
              ),

              SizedBox(height: 10),

              Text(
                "Status: $status",
                style: TextStyle(
                    fontSize: 20, color: Colors.white70),
              ),

              SizedBox(height: 30),

              Text(
                "👆 Double tap: Reorder\n"
                    "✋ Hold: Map\n"
                    "👉 Swipe anywhere",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}