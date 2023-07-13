import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_noteapp/constants/themes.dart';
import 'package:firebase_noteapp/views/note_editor.dart';
import 'package:firebase_noteapp/views/search_screen.dart';
import 'package:firebase_noteapp/widgets/drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/delete_popup.dart';
import '../widgets/note_cards.dart';
import 'add_notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ZoomDrawerController z = ZoomDrawerController();

  String? photoUrl;
  bool showPopup = false;
  bool? haveNotes;

  @override
  void initState() {
    loadString();

    super.initState();
  }

  // void showProfilePopup() {
  //   Navigator.push(context, MaterialPageRoute<void>(
  //     builder: (BuildContext context) {
  //       return Scaffold(
  //         backgroundColor: Colors.transparent,
  //         body: GestureDetector(
  //           onTap: () {
  //             Navigator.pop(context);
  //           },
  //           child: Center(
  //             child: Hero(
  //                 tag: 'profilePicture',
  //                 child: Container(
  //                     height: 100,
  //                     width: 100,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(100),
  //                         image: DecorationImage(
  //                             image: NetworkImage(photoUrl != null
  //                                 ? photoUrl!
  //                                 : 'https://png.pngtree.com/element_our/20190529/ourmid/pngtree-flat-user-pattern-round-avatar-pattern-image_1200096.jpg'),
  //                             fit: BoxFit.cover)))),
  //           ),
  //         ),
  //       );
  //     },
  //   ));
  // }

  // Load the string
  void loadString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myString = prefs.getString('photo')!;

    // Use the loaded string
    setState(() {
      photoUrl = myString;
    });
  }

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
    return ZoomDrawer(
      controller: z,
      borderRadius: 50,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.55,
      duration: const Duration(milliseconds: 500),
      menuBackgroundColor: HexColor('#2B3467'),
      angle: 0.0,
      menuScreen: const DrawerScreen(),
      mainScreen: Scaffold(
        backgroundColor: HexColor('#313552'),
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NoteSearchPage()));
                },
                child: const Icon(
                  Icons.search,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    z.open!();
                  });
                },
                child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(photoUrl != null
                                ? photoUrl!
                                : 'https://img.freepik.com/premium-vector/portrait-beautiful-young-woman_478440-398.jpg?size=626&ext=jpg'),
                            fit: BoxFit.cover))),
              ),
            )
          ],
          leading: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.notes,
              size: 28,
              color: Colors.white,
            ),
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
                  'Your Notes',
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
                      return snapshot.data!.docs.isNotEmpty
                          ? GestureDetector(
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
                                                builder: (context) =>
                                                    NoteEditorPage(
                                                  wholeData: note,
                                                  id: note.id,
                                                ),
                                              ),
                                            );
                                          },
                                          // note,
                                          onLongPress: () {
                                            showDeleteConfirmationDialog(
                                                context,
                                                note.id,
                                                deleteDocument);
                                          },
                                          child: Hero(
                                              tag: 'card${note.id}',
                                              child: noteCard(note)));
                                    }).toList(),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Image.asset(
                                          'assets/bgimages/data-pana.png'),
                                      Text(
                                        'Uh Oh ! No Notes Found\n     Add Some Notes',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Transform.rotate(
                                        angle: -80,
                                        child: Image.asset(
                                          'assets/bgimages/arrow.png',
                                          height: 150,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }
}
