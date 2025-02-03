import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowQuestion extends StatefulWidget {
  final String subjectName;
  final String mockName;

  ShowQuestion({required this.subjectName, required this.mockName});

  @override
  _ShowQuestionState createState() => _ShowQuestionState();
}

class _ShowQuestionState extends State<ShowQuestion> {
  String? editingQuestionId;
  String editedQuestionText = "";
  String? selectedCorrectAnswer;
  String? editingOptionId;
  String? editingExplanationId;
  TextEditingController explanationController = TextEditingController();

  void _updateExplanation(String questionId, String newExplanation) async {
    await FirebaseFirestore.instance
        .collection('series')
        .doc(widget.subjectName)
        .collection('mocks')
        .doc(widget.mockName)
        .collection('questions')
        .doc(questionId)
        .update({'explanation': newExplanation});
    setState(() {
      editingExplanationId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black.withOpacity(0.8),
          title: Text(
            '${widget.mockName} - Questions',
            style: GoogleFonts.acme(color: Colors.white),
          )),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('series')
            .doc(widget.subjectName)
            .collection('mocks')
            .doc(widget.mockName)
            .collection('questions')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Questions Available'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              List<String> options = List<String>.from(doc['options']);

              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Text(
                        doc['question'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Options
                      Column(
                        children: options.map((option) {
                          return Text(option);
                        }).toList(),
                      ),
                      SizedBox(height: 10),

                      // Correct Answer Dropdown
                      DropdownButton<String>(
                        value: options.contains(selectedCorrectAnswer)
                            ? selectedCorrectAnswer
                            : doc['correctAnswer'],
                        items: options.map<DropdownMenuItem<String>>((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedCorrectAnswer = value;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),

                      // Explanation Section
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explanation:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            editingExplanationId == doc.id
                                ? TextField(
                                    controller: explanationController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Edit Explanation",
                                    ),
                                  )
                                : Text(doc['explanation'] ??
                                    "No explanation available"),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (editingExplanationId == doc.id)
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check,
                                            color: Colors.green),
                                        onPressed: () {
                                          _updateExplanation(
                                              doc.id,
                                              explanationController.text
                                                  .trim());
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            editingExplanationId = null;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                else
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        editingExplanationId = doc.id;
                                        explanationController.text =
                                            doc['explanation'] ?? "";
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
