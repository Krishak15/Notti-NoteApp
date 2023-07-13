import 'package:firebase_noteapp/constants/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BgPickerWidget extends StatefulWidget {
  const BgPickerWidget({super.key});

  @override
  State<BgPickerWidget> createState() => _BgPickerWidgetState();
}

class _BgPickerWidgetState extends State<BgPickerWidget> {
  int? selectedImageIndex;
  @override
  Widget build(BuildContext context) {
    AppStyle colorProvider = Provider.of<AppStyle>(context);
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: colorProvider.bgImagesP.length,
      itemBuilder: (context, index) {
        var img = colorProvider.bgImagesP[index];
        bool isSelected = index == selectedImageIndex;
        int isFirst = index;
        return GestureDetector(
          onTap: () {
            // Save the selected color's index
            setState(() {
              selectedImageIndex = index;
              colorProvider.setSelectedImageIndex(index);
              // Navigator.pop(context);
            });
          },
          child: Stack(
            children: [
              isFirst == 0
                  ? const Center(
                      child: Icon(
                        Icons.undo,
                        color: Colors.blueGrey,
                        size: 40,
                      ),
                    )
                  : const SizedBox(),
              Container(
                margin: const EdgeInsets.all(8),
                width: 160,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(img),
                  ),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: isSelected ? 2 : 0,
                  ),
                ),
                child: isFirst == 1
                    ? const SizedBox(
                        height: 70,
                        width: 70,
                        child: Icon(
                          Icons.hide_image,
                          color: Colors.blueGrey,
                          size: 40,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
