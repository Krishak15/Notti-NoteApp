import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_noteapp/constants/themes.dart';
import 'package:firebase_noteapp/views/note_editor.dart';
import 'package:firebase_noteapp/views/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/delete_popup.dart';
import '../widgets/note_cards.dart';
import 'add_notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var ref = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  void deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notes')
          .doc(documentId)
          .delete();
      if (kDebugMode) {
        print("Document deleted successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting document: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NoteSearchPage()));
              },
              child: const Icon(
                Icons.search,
                size: 28,
                color: Colors.white,
              ),
            ),
          )
        ],
        leading: const Icon(
          Icons.notes,
          size: 28,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 9,
                bottom: 12,
              ),
              child: Text(
                'Recent Notes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('notes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return InkWell(
                      child: Builder(
                        builder: (context) {
                          return GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            children: snapshot.data!.docs.map((note) {
                              // int index = snapshot.data!.docs.indexOf(note);
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteEditorPage(
                                          wholeData: note,
                                          id: note.id,
                                        ),
                                      ),
                                    );
                                  },
                                  // note,
                                  onLongPress: () {
                                    showDeleteConfirmationDialog(
                                        context, note.id, deleteDocument);
                                  },
                                  child: Hero(
                                      tag: 'card${note.id}',
                                      child: noteCard(note)));
                            }).toList(),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.purple,
                      strokeWidth: 1.6,
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNotesPage(),
              ));
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
