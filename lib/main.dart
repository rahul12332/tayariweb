import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'adminPart/core/contant/appColor.dart';
import 'adminPart/dbFirebase/firebase_service.dart';
import 'adminPart/view/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppColor.theme, // Set navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Set icon brightness
      statusBarColor: AppColor.theme, // Set status bar color
      statusBarIconBrightness:
          Brightness.light, // Set status bar icon brightness
    ),
  );
  if (kIsWeb) {
    await FirebaseService().initializeFirebase();
  } else {
    await Firebase.initializeApp();
  }
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Quiz Admin',
      theme: ThemeData(
        primaryColor: AppColor.theme, // Apply primary color from the constants
        scaffoldBackgroundColor: AppColor.pistelGray, // Set background color
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.theme,
          titleTextStyle: GoogleFonts.acme(
            // Apply Google Font to AppBar title
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),

          // Use the primary color for AppBar
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColor.buttonColor, // Use primary color for buttons
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.aclonica(
            color: AppColor.textColor,
            letterSpacing: 1,
          ), // Customize text if needed
        ),
      ),
      home: SplashScreen(),
    );
  }
}
