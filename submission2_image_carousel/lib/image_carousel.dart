import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int currentIndex = 0;
  final List<String> images = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];

  
  void nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % images.length; 
    });
  }

  void prevImage() {
    setState(() {
      currentIndex = (currentIndex - 1 + images.length) % images.length; 
    });
  }

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 400;
    const double imageHeight = 550;
    const double buttonAreaHeight = 60;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                images[currentIndex],
                fit: BoxFit.cover, 
              ),
            ),
            Container(
              height: buttonAreaHeight,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: prevImage,
                    iconSize: 40,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: nextImage,
                    iconSize: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}