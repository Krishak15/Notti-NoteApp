import 'package:firebase_noteapp/constants/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({super.key});

  @override
  ColorPickerWidgetState createState() => ColorPickerWidgetState();
}

class ColorPickerWidgetState extends State<ColorPickerWidget> {
  int? selectedColorIndex;

  @override
  Widget build(BuildContext context) {
    AppStyle colorProvider = Provider.of<AppStyle>(context);
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: colorProvider.cardsColor.length,
      itemBuilder: (context, index) {
        Color color = colorProvider.cardsColor[index];

        bool isSelected = index == selectedColorIndex;

        int isFirst = index;

        return GestureDetector(
          onTap: () {
            // Save the selected color's index
            setState(() {
              selectedColorIndex = index;
              colorProvider.setSelectedColorIndex(index);
              // Navigator.pop(context);
            });
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: color,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
            ),
            child: isFirst == 0
                ? const Icon(Icons.undo, color: Colors.blueGrey, size: 24)
                : null,
          ),
        );
      },
    );
  }
}
