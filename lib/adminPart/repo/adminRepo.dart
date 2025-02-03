import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/adminPart/domain/sharedPre.dart';
import 'package:fast_quiz_tayari/adminPart/view/dashboard.dart';
import 'package:fast_quiz_tayari/adminPart/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/CustomCircularProgress.dart';

class FirebaseRepo {
  // Static instance of FirebaseAuth and FirebaseFirestore
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Static method to create a root directory in Firebase
  static Future<void> createRootDirectory() async {
    try {
      // Create root directory in Firestore with a sample collection
      CollectionReference users = _firestore.collection('admin');

      // Add a document with admin credentials
      await users.doc('admin_credentials').set({
        'email': 'amitchandra@gmail.com',
        'password': 'Amit@1234',
      });

      print('Root directory and admin credentials created successfully');
    } catch (e) {
      print('Error creating root directory: $e');
    }
  }

  // Static method to login and match the admin credentials
  static Future<bool> login({
    required String email,
    required String password,
    required BuildContext context, // Pass the context for dialog
  }) async {
    // Show loading dialog while checking credentials
    showDialog(
      context: context,
      barrierDismissible: false, // Don't allow dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set the background to white
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Logging in..."),
            ],
          ),
        );
      },
    );

    try {
      // Fetch the stored admin credentials from Firestore
      DocumentSnapshot snapshot =
          await _firestore.collection('admin').doc('admin_credentials').get();

      // Check if the document exists and validate credentials
      if (snapshot.exists) {
        String storedEmail = snapshot['email'];
        String storedPassword = snapshot['password'];

        // Compare provided credentials with stored credentials
        if (storedEmail == email && storedPassword == password) {
          // Simulate a small delay before navigating to the dashboard
          await Future.delayed(const Duration(seconds: 2));

          // Dismiss the loading dialog
          Navigator.of(context).pop();
          await SharedPrefs().saveEmail(email);

          // Navigate to Dashboard after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ), // Replace with your dashboard screen
          );

          return true; // Admin login successful
        } else {
          // Dismiss the loading dialog
          Navigator.of(context).pop();

          // Show error dialog if credentials are incorrect
          showErrorDialog(context, "Invalid credentials. Please try again.");
          return false; // Incorrect credentials
        }
      } else {
        print('Admin credentials not found.');
        // Dismiss the loading dialog
        Navigator.of(context).pop();

        // Show error dialog if admin credentials are not found
        return false;
      }
    } catch (e) {
      // Dismiss the loading dialog
      Navigator.of(context).pop();
      print('Error during login: $e');
      return false;
    }
  }

  static Future<void> logout(BuildContext context) async {
    try {
      // Clear shared preferences
      await SharedPrefs().clearUserData();

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ), // Replace with your dashboard screen
      );
    } catch (e) {
      // Handle errors, if any
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }
}

//jjjjjjjjgi
