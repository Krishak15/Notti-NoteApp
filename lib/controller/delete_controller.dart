import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
