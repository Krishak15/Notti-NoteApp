import 'package:flutter/material.dart';

class AppStyle with ChangeNotifier {
  List<Color> get cardsColor => [
        const Color(0xFFD1C4E9), // Lavender
        const Color(0xFF90CAF9), // Light Blue
        const Color(0xFFB2DFDB), // Mint
        const Color(0xFFFFCC80), // Apricot
        const Color(0xFFBDBDBD), // Gray
        const Color(0xFFF0B27A), // Peach
        const Color(0xFFE6EE9C),
        const Color.fromARGB(255, 255, 159,
            218), // Peach// Light Green/ Light Grayconst Color(0xFFF5F5F5), // White Smoke
      ];

  List get bgImagesP => [
        'assets/bgimages/empty.png',
        'assets/bgimages/camel.png',
        'assets/bgimages/bulb.png',
        'assets/bgimages/hillclouds.png',
        'assets/bgimages/mountains.png',
        'assets/bgimages/phoenix.png',
        'assets/bgimages/rocket.png',
        'assets/bgimages/cassette.png',
      ];

  int _selectedColorIndex = 1;
  int _selectedImageIndex = 0;

  int get selectedColorIndex => _selectedColorIndex;
  int get selectedImageIndex => _selectedImageIndex;

  void setSelectedColorIndex(int index) {
    _selectedColorIndex = index;
    notifyListeners();
  }

  void setSelectedImageIndex(int index) {
    _selectedImageIndex = index;
    notifyListeners();
  }
}

List<Color> get cardsColori => [
      const Color(0xFFD1C4E9), // Lavender
      const Color(0xFF90CAF9), // Light Blue
      const Color(0xFFB2DFDB), // Mint
      const Color(0xFFFFCC80), // Apricot
      const Color(0xFFBDBDBD), // Gray
      const Color(0xFFF0B27A), // Peach

      const Color(0xFFE6EE9C),
      const Color.fromARGB(255, 255, 159,
          218), // Peach// Light Green/ Light Grayconst Color(0xFFF5F5F5), // White Smoke
    ];

List get bgImages => [
      'assets/bgimages/empty.png',
      'assets/bgimages/camel.png',
      'assets/bgimages/bulb.png',
      'assets/bgimages/hillclouds.png',
      'assets/bgimages/mountains.png',
      'assets/bgimages/phoenix.png',
      'assets/bgimages/rocket.png',
      'assets/bgimages/cassette.png',
    ];
