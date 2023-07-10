// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_noteapp/views/note_editor.dart';
// import 'package:firebase_noteapp/views/note_viewer.dart';
// import 'package:firebase_noteapp/widgets/note_cards.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nottee'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Your notes', style: TextStyle(fontSize: 24)),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream:
//                   FirebaseFirestore.instance.collection("Notes").snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.blueGrey,
//                       strokeWidth: 1.6,
//                     ),
//                   );
//                 }
//                 if (snapshot.hasData) {
//                   return GridView(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2),
//                     children: snapshot.data!.docs
//                         .map((note) => noteCard(() {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => NoteViewer(doc: note),
//                                   ));
//                             }, note))
//                         .toList(),
//                   );
//                 }
//                 return const Center(child: Text('Your book is empty !'));
//               },
//             ),
//           )
//         ]),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const NoteEditorPage(),
//               ));
//         },
//         label: const Text('Add Note'),
//         icon: const Icon(Icons.add),
//       ),
//     );
//   }
// }
