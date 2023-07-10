import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_noteapp/constants/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteViewer extends StatefulWidget {
  var doc;

  NoteViewer({required this.doc, super.key});

  @override
  State<NoteViewer> createState() => _NoteViewerState();
}

class _NoteViewerState extends State<NoteViewer> {
  @override
  Widget build(BuildContext context) {
    AppStyle colorProvider = Provider.of<AppStyle>(context);
    int colorId = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: colorProvider.cardsColor[colorId],
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.doc['title']),
          Text(widget.doc['created'].toString()),
          Text(widget.doc['description']),
        ],
      ),
    );
  }
}
