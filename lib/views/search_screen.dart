import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_noteapp/constants/themes.dart';
import 'package:firebase_noteapp/views/note_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../constants/appstyles.dart';
import '../widgets/search_txtfield.dart';

class NoteSearchPage extends StatefulWidget {
  const NoteSearchPage({super.key});

  @override
  _NoteSearchPageState createState() => _NoteSearchPageState();
}

class _NoteSearchPageState extends State<NoteSearchPage> {
  List<DocumentSnapshot> searchResults = [];

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Search function

  void searchNotes(String query) {
    CollectionReference notesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');
    //
    String lowercaseQuery =
        query.toLowerCase(); //it converts the search text we enter to lowercase
    //

    notesRef.get().then((querySnapshot) {
      //
      List<DocumentSnapshot> allNotes = querySnapshot.docs;
      //
      List<DocumentSnapshot> filteredNotes = allNotes.where((note) {
        //
        String title = note.get('title').toString().toLowerCase(); //Note title
        String description =
            note.get('description').toString().toLowerCase(); //Note description
        //
        return title.contains(lowercaseQuery) ||
            description.contains(lowercaseQuery);
      }).toList();
      //
      setState(() {
        searchResults = filteredNotes;
      });
    });
  }

  //
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#313552'),
      appBar: AppBar(
        title: const Text('Note Search'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SearchTextField(
              searchController: searchController,
              onChangeSearchText: (value) {
                searchNotes(value);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('notes')
                    .snapshots(),
                builder: (context, snapshot) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot note = searchResults[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteEditorPage(wholeData: note, id: note.id),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(bgImages[note['image_id']]),
                                  fit: BoxFit.cover),
                              color: cardsColori[note['color_id']],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            note['title'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                                child: Text(
                                              note['description'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                note['created'].toString(),
                                style: GoogleFonts.poppins(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
