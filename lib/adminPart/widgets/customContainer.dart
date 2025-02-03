import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainer extends StatefulWidget {
  final String text;
  final VoidCallback onPressed; // Add onPressed callback to handle button press

  const CustomContainer({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: ElevatedButton(
          onPressed: widget.onPressed, // Handle button press
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.grey.shade50,
            backgroundColor: isHovered
                ? Colors.orangeAccent.shade100
                : Colors.white, // Hover effect
            elevation: isHovered ? 3 : 1, // Elevation on hover
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
          ),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            height: 50,
            child: Text(
              widget.text,
              style: GoogleFonts.acme(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: isHovered
                    ? Colors.blue
                    : Colors.grey.shade500, // Text color on hover
              ),
            ),
          ),
        ),
      ),
    );
  }
}
