import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> updateFolder(
    {required String docId,
    required String currentName,
    required BuildContext context}) async {
  TextEditingController nameController = TextEditingController(
    text: currentName,
  );

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Update Folder'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Folder Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance
                      .collection('series')
                      .doc(docId)
                      .update({'name': nameController.text.trim()});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Folder updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update folder: $e')),
                  );
                }
              }
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
}

Future<void> deleteFolder(
    {required String docId, required BuildContext context}) async {
  try {
    await FirebaseFirestore.instance.collection('series').doc(docId).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Folder deleted successfully')));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to delete folder: $e')));
  }
}
