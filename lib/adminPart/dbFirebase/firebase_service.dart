import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  // Firebase configuration options
  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyChAwBjCHmlSw0qaiEt7h90h9LLftGlDtg",
    authDomain: "crackexam-79f0c.firebaseapp.com",
    projectId: "crackexam-79f0c",
    storageBucket: "crackexam-79f0c.appspot.com",
    messagingSenderId: "391233130466",
    appId: "1:391233130466:web:a2149bd71b980567e2b3bb",
    measurementId: "G-SSKFR0LLK8",
  );

  // Singleton instance
  static final FirebaseService _instance = FirebaseService._internal();

  FirebaseService._internal();

  factory FirebaseService() => _instance;

  // Firebase Analytics instance

  // Method to initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(options: firebaseOptions);
      print("Firebase initialized successfully.");
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }

  // delete mock
  static Future<void> deleteMockFolder(
      {required String mockName,
      required String subjectName,
      required BuildContext context}) async {
    final mockCollection = FirebaseFirestore.instance
        .collection('series')
        .doc(subjectName)
        .collection('mocks');

    await mockCollection.doc(mockName).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Folder "$mockName" deleted!')));
  }

  static Future<int> getTotalQuestions(
      String subjectName, String mockName) async {
    QuerySnapshot questionSnapshot = await FirebaseFirestore.instance
        .collection('series')
        .doc(subjectName)
        .collection('mocks')
        .doc(mockName)
        .collection('questions')
        .get();
    return questionSnapshot.docs.length;
  }
}
