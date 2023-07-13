import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_noteapp/constants/appstyles.dart';
import 'package:firebase_noteapp/widgets/bg_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/color_picker.dart';

class NoteEditorPage extends StatefulWidget {
  final id;

  final wholeData;
  const NoteEditorPage({super.key, required this.id, required this.wholeData});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  String? title;
  String? description;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  int? colorID;
  int? selectedColorIndex = 0;
  int? selectedImageIndex = 0;

  // String date = DateTime.now().toString();

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('y MMMM EEEE d, hh:mm');
    String formattedDateTime = formatter.format(now);
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    //initial text to edit
    _titleController.text = widget.wholeData['title'];
    _contentController.text = widget.wholeData['description'];

    AppStyle colorProvider = Provider.of<AppStyle>(context);
    colorID = Random().nextInt(colorProvider.cardsColor.length);

    void resetIndex() {
      colorProvider.setSelectedImageIndex(0);
      colorProvider.setSelectedColorIndex(0);
    }

    selectedColorIndex = colorProvider.selectedColorIndex;
    selectedImageIndex = colorProvider.selectedImageIndex;

    //
    //

    int myImageVariable = selectedImageIndex!;
    int myColorVariable = selectedColorIndex!;
    const previousValue = 0;

    void checkImageVariableChane() {
      if (myImageVariable != previousValue) {
        // Value has changed
        if (myImageVariable == selectedImageIndex) {
          if (kDebugMode) {
            print('The variable has changed to $myImageVariable');
          }
        } else {
          // Perform some action for other changed values
          if (kDebugMode) {
            print('The variable has changed to a different value');
          }
        }
      } else {
        myImageVariable = widget.wholeData['image_id']; // Value has not changed
      }

      //if variable match firebase value
      if (myImageVariable == widget.wholeData['image_id']) {
        myImageVariable = widget.wholeData['image_id'];
        colorProvider.setSelectedImageIndex(0);
        if (kDebugMode) {
          print("Firebase image_id matched the previous value");
        }
      }
    }

    //

    void checkColorVariableChange() {
      if (myColorVariable != previousValue) {
        // Value has changed
        if (myColorVariable == selectedColorIndex) {
          if (kDebugMode) {
            print('The variable has changed to $myColorVariable');
          }
        } else {
          // Perform some action for other changed values
          if (kDebugMode) {
            print('The variable has changed to a different value');
          }
        }
      } else {
        myColorVariable = widget.wholeData['color_id']; // Value has not changed
      }

      //if variable match firebase value
      if (myColorVariable == widget.wholeData['color_id']) {
        myColorVariable = widget.wholeData['color_id'];
        colorProvider.setSelectedColorIndex(0);
        if (kDebugMode) {
          print("Firebase color_id matched the previous value");
        }
      }
    }
    //

    final snapShotData = widget.wholeData;

    return WillPopScope(
      onWillPop: () async {
        resetIndex();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Add Note"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Hero(
          tag: 'card${widget.id}',
          child: Material(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: selectedColorIndex == 0
                    ? colorProvider.cardsColor[snapShotData['color_id']]
                    : colorProvider.cardsColor[selectedColorIndex!],
                image: DecorationImage(
                    image: AssetImage(selectedImageIndex == 0
                        ? colorProvider.bgImagesP[snapShotData['image_id']]
                        : colorProvider.bgImagesP[selectedImageIndex!]),
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
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15),
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600),
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
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 10),
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w400),
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
                                            return const SingleChildScrollView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                        height: 400,
                                                        child:
                                                            ColorPickerWidget()),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Icon(
                                      Icons.color_lens,
                                      size: 30,
                                      color: Colors.blueGrey.shade800,
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
                                            return const SingleChildScrollView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                        height: 400,
                                                        child:
                                                            BgPickerWidget()),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.blueGrey.shade800,
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
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            checkImageVariableChane();
            checkColorVariableChange();
            if (_titleController.text.isNotEmpty &&
                _contentController.text.isNotEmpty) {
              updateData(myImageVariable, myColorVariable);
              // colorProvider.setSelectedImageIndex(0);
            } else {
              const snackBar = SnackBar(
                content: Text('Add Something !'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          label: Text('Save'),
          icon: Icon(Icons.save_rounded),
        ),
      ),
    );
  }

  void updateData(int myVarImageId, int myVarColorId) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

    DocumentReference docRef = ref.doc(widget.id);

    var data = {
      "title": title ?? _titleController.text,
      "description": description ?? _contentController.text,
      "color_id": myVarColorId,
      "image_id": myVarImageId,
      "created": getFormattedDateTime()
    };
    docRef.update(data);

    //
    selectedImageIndex = 0;
    selectedColorIndex = 0;
    print(selectedImageIndex);
    print(selectedColorIndex);
    //

    Navigator.pop(context);
  }
}
