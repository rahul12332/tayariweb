import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerContainer extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const DrawerContainer({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        margin: EdgeInsets.symmetric(vertical: 10), // Optional margin
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.orange, // Border color
            width: 0.5, // Border width
          ),
          borderRadius: BorderRadius.circular(2), // Rounded corners
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.acme(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.orange, // Text color
            ),
          ),
        ),
      ),
    );
  }
}
