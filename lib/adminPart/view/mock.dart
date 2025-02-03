import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/adminPart/view/question.dart';
import 'package:fast_quiz_tayari/adminPart/view/showQuestion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dbFirebase/firebase_service.dart';

class MockList extends StatefulWidget {
  final String subjectName;

  MockList({Key? key, required this.subjectName}) : super(key: key);

  @override
  State<MockList> createState() => _MockListState();
}

class _MockListState extends State<MockList> {
  final TextEditingController _mockNameController = TextEditingController();

  Future<void> _addMockFolder(String mockName, bool isPaid) async {
    final mockCollection = FirebaseFirestore.instance
        .collection('series')
        .doc(widget.subjectName)
        .collection('mocks');

    final existingMock = await mockCollection.doc(mockName).get();

    if (existingMock.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Folder "$mockName" already exists!')),
      );
    } else {
      await mockCollection.doc(mockName).set({
        'name': mockName,
        'paid': isPaid, // Use the user-selected value
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Folder "$mockName" added successfully!')),
      );

      setState(() {}); // Refresh UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.7),
        title: Row(
          children: [
            Text(
              'Fast Quiz App',
              style: GoogleFonts.robotoSerif(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 400,
            ),
            Expanded(
                child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'Profile',
                    style: GoogleFonts.robotoSerif(
                        fontSize: 16, color: Colors.white, letterSpacing: 2),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String selectedPaidStatus = 'true'; // Default selection

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Mock Folder'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _mockNameController,
                      decoration: InputDecoration(
                        labelText: 'Mock Name (e.g., Mock 1)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedPaidStatus,
                      decoration: InputDecoration(
                        labelText: "Paid Status",
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                            value: 'true', child: Text('Paid (True)')),
                        DropdownMenuItem(
                            value: 'false', child: Text('Free (False)')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          selectedPaidStatus = value;
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        final mockName = _mockNameController.text.trim();
                        if (mockName.isNotEmpty) {
                          bool isPaid = selectedPaidStatus == 'true';
                          _addMockFolder(mockName,
                              isPaid); // Call method with user's choice
                          _mockNameController.clear();
                          Navigator.pop(context); // Close dialog
                        }
                      },
                      child: Text('Add'),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        // Center the entire ListView
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Constrain width
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('series')
                .doc(widget.subjectName)
                .collection('mocks')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No Mocks Added'));
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> docData =
                      doc.data() as Map<String, dynamic>;

                  return FutureBuilder<int>(
                    future: FirebaseService.getTotalQuestions(
                        widget.subjectName, docData['name']),
                    builder: (context, questionSnapshot) {
                      int totalQuestions = questionSnapshot.data ?? 0;
                      bool isPaid =
                          docData.containsKey('paid') ? docData['paid'] : false;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10), // Spacing between items
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center elements horizontally
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      2), // Rectangular border with radius 2
                                ),
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(docData['name']),
                                  subtitle:
                                      Text('Total Questions: $totalQuestions'),
                                  trailing: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: isPaid ? Colors.red : Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isPaid ? 'Paid' : 'Free',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowQuestion(
                                          subjectName: widget.subjectName,
                                          mockName: docData['name'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            // Delete Button (Red)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red, // Red color for delete
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () {
                                FirebaseService.deleteMockFolder(
                                  mockName: docData['name'],
                                  subjectName: widget.subjectName,
                                  context: context,
                                );
                              },
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            SizedBox(width: 20),
                            // Add Button (Green)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // Green color for add
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddQuestionScreen(
                                      subjectName: widget.subjectName,
                                      mockName: docData['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
