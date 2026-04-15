import 'package:flutter/material.dart';

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviePage(),
    );
  }
}

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Map<String, dynamic>> movies = [
    {
      "title": "Inception",
      "genre": "Sci-Fi",
      "poster":
      "https://m.media-amazon.com/images/I/51zUbui+gbL._AC_.jpg",
      "rating": 0
    },
    {
      "title": "Avengers",
      "genre": "Action",
      "poster":
      "https://m.media-amazon.com/images/I/81ExhpBEbHL._AC_SL1500_.jpg",
      "rating": 0
    },
    {
      "title": "Interstellar",
      "genre": "Drama",
      "poster":
      "https://m.media-amazon.com/images/I/71niXI3lxlL._AC_SL1178_.jpg",
      "rating": 0
    }
  ];

  Color getColor(int rating) {
    if (rating >= 4) return Colors.green.shade300;
    if (rating == 3) return Colors.orange.shade300;
    if (rating > 0 && rating < 3) return Colors.red.shade300;
    return Colors.white;
  }

  Widget buildStars(int index) {
    return Row(
      children: List.generate(5, (starIndex) {
        return IconButton(
          icon: Icon(
            starIndex < movies[index]['rating']
                ? Icons.star
                : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              movies[index]['rating'] = starIndex + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Review App")),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return AnimatedContainer(
            duration: Duration(milliseconds: 400),
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: getColor(movie['rating']),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5)
              ],
            ),
            child: Row(
              children: [
                /// POSTER
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie['poster'],
                    height: 120,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: 15),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['title'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text("Genre: ${movie['genre']}"),

                      SizedBox(height: 10),

                      /// STARS
                      buildStars(index),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}