import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomePage(),
    );
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List meals = [];
  String query = "chicken";

  @override
  void initState() {
    super.initState();
    fetchRecipes(query);
  }

  Future<void> fetchRecipes(String search) async {
    final response = await http.get(
      Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s=$search"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        meals = data['meals'] ?? [];
      });
    }
  }

  void searchRecipe(String text) {
    setState(() {
      query = text;
    });
    fetchRecipes(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe App"),
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
              onSubmitted: searchRecipe,
            ),
          ),
          Expanded(
            child: meals.isEmpty
                ? Center(child: Text("No recipes found"))
                : ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      var meal = meals[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(
                            meal['strMealThumb'],
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(meal['strMeal']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(meal: meal),
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
  final dynamic meal;

  DetailPage({required this.meal});

  List<String> getIngredients() {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      String? ingredient = meal['strIngredient$i'];
      String? measure = meal['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add("$ingredient - $measure");
      }
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    List<String> ingredients = getIngredients();

    return Scaffold(
      appBar: AppBar(
        title: Text(meal['strMeal']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal['strMealThumb']),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Ingredients",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...ingredients.map((ing) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("• $ing"),
                )),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Method",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(meal['strInstructions']),
            ),
          ],
        ),
      ),
    );
  }
}
