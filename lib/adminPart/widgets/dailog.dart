import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/adminPart/core/contant/appColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSubjectDialog extends StatelessWidget {
  final VoidCallback onSubjectAdded;

  AddSubjectDialog({required this.onSubjectAdded});

  @override
  Widget build(BuildContext context) {
    final TextEditingController subjectController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          // Rectangular shape with slight rounding
          ),
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.2, // Define dialog width as 20% of screen width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Subject Folder',
              style:
                  GoogleFonts.acme(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade200, width: 0.8), // Outer border
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextFormField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Folder Name',
                  border: InputBorder.none, // Remove TextFormField border
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.acme(color: AppColor.redColor),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: AppColor.theme),
                    onPressed: () async {
                      String subjectName = subjectController.text.trim();

                      if (subjectName.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('series')
                            .doc(subjectName)
                            .set({'name': subjectName});

                        onSubjectAdded();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Add',
                      style: GoogleFonts.acme(
                          color: Colors.white, letterSpacing: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
