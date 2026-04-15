import 'package:flutter/material.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Manager',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const BookScreen(),
    );
  }
}

class Book {
  String title;
  String author;
  bool isFavorite;

  Book({required this.title, required this.author, this.isFavorite = false});
}

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredBooks = books;
  }

  void addBook(String title, String author) {
    setState(() {
      books.add(Book(title: title, author: author));
      filteredBooks = books;
    });
  }

  void deleteBook(int index) {
    setState(() {
      books.removeAt(index);
      filteredBooks = books;
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      filteredBooks[index].isFavorite =
      !filteredBooks[index].isFavorite;
    });
  }

  void editBook(int index, String newTitle, String newAuthor) {
    setState(() {
      filteredBooks[index].title = newTitle;
      filteredBooks[index].author = newAuthor;
    });
  }

  void searchBooks(String query) {
    setState(() {
      filteredBooks = books
          .where((b) =>
      b.title.toLowerCase().contains(query.toLowerCase()) ||
          b.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showBookDialog({int? index}) {
    final titleController = TextEditingController(
        text: index != null ? filteredBooks[index].title : "");
    final authorController = TextEditingController(
        text: index != null ? filteredBooks[index].author : "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? "Add Book" : "Edit Book"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: authorController, decoration: const InputDecoration(labelText: "Author")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (index == null) {
                addBook(titleController.text, authorController.text);
              } else {
                editBook(index, titleController.text, authorController.text);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Management"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBookDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          /// 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search books...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: searchBooks,
            ),
          ),

          /// 📚 Book List
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.author),
                    leading: IconButton(
                      icon: Icon(
                        book.isFavorite ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () => toggleFavorite(index),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showBookDialog(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteBook(index),
                        ),
                      ],
                    ),
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