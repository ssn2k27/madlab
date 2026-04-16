import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App (Dummy API)',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

// ---------------- DUMMY API ----------------
class DummyAPI {
  static Future<List<Map<String, dynamic>>> fetchRecipes() async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay

    return [
      {
        "name": "Chicken Curry",
        "image":
            "https://www.themealdb.com/images/media/meals/1529446352.jpg",
        "ingredients": [
          "Chicken - 500g",
          "Onion - 2",
          "Tomato - 2",
          "Spices"
        ],
        "method":
            "Heat oil, sauté onions, add tomatoes and spices, add chicken, cook until done."
      },
      {
        "name": "Pasta",
        "image":
            "https://www.themealdb.com/images/media/meals/wvqpwt1468339226.jpg",
        "ingredients": [
          "Pasta",
          "Tomato Sauce",
          "Garlic",
          "Cheese"
        ],
        "method":
            "Boil pasta, prepare sauce, mix together, add cheese and serve."
      },
      {
        "name": "Fried Rice",
        "image":
            "https://www.themealdb.com/images/media/meals/1529443236.jpg",
        "ingredients": [
          "Rice",
          "Vegetables",
          "Soy Sauce",
          "Egg"
        ],
        "method":
            "Stir fry vegetables, add rice, mix soy sauce, scramble egg and combine."
      }
    ];
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List recipes = [];
  List filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void loadRecipes() async {
    var data = await DummyAPI.fetchRecipes();
    setState(() {
      recipes = data;
      filteredRecipes = data;
    });
  }

  void search(String query) {
    setState(() {
      filteredRecipes = recipes
          .where((r) =>
              r['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe App (Dummy API)"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search recipes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: search,
            ),
          ),
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(child: Text("No recipes found"))
                : ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      var recipe = filteredRecipes[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(
                            recipe['image'],
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(recipe['name']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailPage(recipe: recipe),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------- DETAIL PAGE ----------------
class DetailPage extends StatelessWidget {
  final dynamic recipe;

  DetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe['image']),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Ingredients",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...recipe['ingredients'].map<Widget>((ing) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("• $ing"),
                )),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Method",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(recipe['method']),
            ),
          ],
        ),
      ),
    );
  }
}
