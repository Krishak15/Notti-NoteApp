import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(
    BuildContext context, String documentId, var document) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              document(documentId);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
