import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_noteapp/constants/appstyles.dart';
import 'package:firebase_noteapp/widgets/bg_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/color_picker.dart';

class AddNotesPage extends StatefulWidget {
  const AddNotesPage({super.key});

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  String? title;
  String? description;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int? colorID;
  int? selectedColorIndex = 1;
  int? selectedImageIndex;

  // String date = DateTime.now().toString();

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('y MMMM EEEE d, hh:mm');
    String formattedDateTime = formatter.format(now);
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    AppStyle colorProvider = Provider.of<AppStyle>(context);
    colorID = Random().nextInt(colorProvider.cardsColor.length);

    selectedColorIndex = colorProvider.selectedColorIndex;
    selectedImageIndex = colorProvider.selectedImageIndex;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Add Note"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: colorProvider.cardsColor[selectedColorIndex ?? colorID!],
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage(colorProvider.bgImagesP[selectedImageIndex ?? 1]),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(getFormattedDateTime()),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Note Title',
                        ),
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: _contentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Note Content',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                height: 200,
                                                child: ColorPickerWidget()),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.color_lens,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                height: 300,
                                                child: BgPickerWidget()),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.image,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_titleController.text.isNotEmpty &&
              _contentController.text.isNotEmpty) {
            addData();
          } else {
            const snackBar = SnackBar(
              content: Text('Add Something !'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          // FirebaseFirestore.instance.collection("Notes").add({
          //   "note_title": _titleController.text,
          //   "note_content": _contentController.text,
          //   "creation_date": date,
          //   "color_id": colorID,
          // }).then((value) {
          //   Navigator.pop(context);
          // }).catchError((error) => print('Failed to add note: $error'));
        },
        label: Text('Save'),
        icon: Icon(Icons.save_rounded),
      ),
    );
  }

  void addData() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

    var data = {
      "title": title,
      "description": description,
      "color_id": selectedColorIndex,
      "image_id": selectedImageIndex,
      "created": getFormattedDateTime()
    };
    ref.add(data);

    //
    //
    Navigator.pop(context);
  }
}
