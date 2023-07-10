import 'package:firebase_noteapp/constants/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorPickerWidget extends StatefulWidget {
  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  int? selectedColorIndex;

  @override
  Widget build(BuildContext context) {
    AppStyle colorProvider = Provider.of<AppStyle>(context);
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: colorProvider.cardsColor.length,
      itemBuilder: (context, index) {
        Color color = colorProvider.cardsColor[index];
        bool isSelected = index == selectedColorIndex;

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
          ),
        );
      },
    );
  }
}
