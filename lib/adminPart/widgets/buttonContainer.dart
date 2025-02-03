import 'package:flutter/cupertino.dart';

class CustomButtonContainer extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const CustomButtonContainer({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(12),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}
