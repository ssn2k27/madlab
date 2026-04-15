import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gesture Gallery',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int currentIndex = 0;
  double scale = 1.0;

  List<String> images = [
    "https://picsum.photos/id/1011/500",
    "https://picsum.photos/id/1015/500",
    "https://picsum.photos/id/1020/500",
    "https://picsum.photos/id/1024/500",
  ];

  Set<int> favorites = {};

  int tapCount = 0;
  Timer? tapTimer;

  void handleTap() {
    tapCount++;

    tapTimer?.cancel();
    tapTimer = Timer(const Duration(milliseconds: 400), () {
      if (tapCount == 2) {
        toggleFavorite();
      } else if (tapCount == 3) {
        deleteImage();
      }
      tapCount = 0;
    });
  }

  void toggleFavorite() {
    setState(() {
      if (favorites.contains(currentIndex)) {
        favorites.remove(currentIndex);
      } else {
        favorites.add(currentIndex);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Toggled Favorite ❤️")),
    );
  }

  void deleteImage() {
    if (images.isEmpty) return;

    setState(() {
      images.removeAt(currentIndex);
      if (currentIndex >= images.length) {
        currentIndex = images.length - 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image Deleted ❌")),
    );
  }

  void nextImage() {
    if (currentIndex < images.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void prevImage() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Images Left")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gesture Image Gallery"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: handleTap,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            nextImage();
          } else {
            prevImage();
          }
        },
        onScaleUpdate: (details) {
          setState(() {
            scale = details.scale.clamp(1.0, 4.0);
          });
        },
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Image ${currentIndex + 1} of ${images.length}"),
            ),
          );
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    images[currentIndex],
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// ❤️ Favorite Icon
              if (favorites.contains(currentIndex))
                const Positioned(
                  top: 20,
                  right: 20,
                  child: Icon(Icons.favorite,
                      color: Colors.red, size: 40),
                ),
            ],
          ),
        ),
      ),
    );
  }
}