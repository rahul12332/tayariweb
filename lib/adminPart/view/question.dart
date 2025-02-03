import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddQuestionScreen extends StatefulWidget {
  final String subjectName;
  final String mockName;

  const AddQuestionScreen(
      {super.key, required this.subjectName, required this.mockName});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _explanationController =
      TextEditingController(); // Explanation field
  final List<TextEditingController> _optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  String? _correctAnswer;
  bool _isSaveEnabled = false;

  // Add question to Firestore
  Future<void> _addQuestion() async {
    final questionText = _questionController.text.trim();
    final explanationText = _explanationController.text.trim();
    final options = _optionControllers
        .map((controller) => controller.text.trim())
        .where((option) => option.isNotEmpty)
        .toList();
    final correctAnswer = _correctAnswer?.trim();

    if (questionText.isNotEmpty &&
        options.length == _optionControllers.length &&
        correctAnswer != null &&
        options.contains(correctAnswer) &&
        explanationText.isNotEmpty) {
      try {
        final questionsCollection = FirebaseFirestore.instance
            .collection('series')
            .doc(widget.subjectName)
            .collection('mocks')
            .doc(widget.mockName)
            .collection('questions');

        // Create a new document to get the auto-generated ID
        DocumentReference newQuestionRef = questionsCollection.doc();

        await newQuestionRef.set({
          'key': newQuestionRef.id, // Store the auto-generated ID
          'question': questionText,
          'options': options,
          'correctAnswer': correctAnswer,
          'explanation': explanationText, // Store explanation
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question added successfully!')),
        );

        // Clear fields after successful submission
        _questionController.clear();
        _explanationController.clear();
        for (var controller in _optionControllers) {
          controller.clear();
        }

        setState(() {
          _correctAnswer = null;
          _isSaveEnabled = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add question. Please try again!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly!')),
      );
    }
  }

  // Check form validity
  void _checkFormValidity() {
    setState(() {
      _isSaveEnabled = _questionController.text.trim().isNotEmpty &&
          _optionControllers
              .every((controller) => controller.text.trim().isNotEmpty) &&
          _correctAnswer != null &&
          _explanationController.text
              .trim()
              .isNotEmpty; // Check if explanation is filled
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text(
          '${widget.subjectName} - ${widget.mockName} - Add Question',
          style: GoogleFonts.acme(color: Colors.white, letterSpacing: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Enter your question',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                onChanged: (_) => _checkFormValidity(),
              ),
              SizedBox(height: 16),
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _optionControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Option ${i + 1}',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      _checkFormValidity();
                      setState(() {}); // Update dropdown options dynamically
                    },
                  ),
                ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButton<String>(
                  value: _correctAnswer,
                  hint: Text('Select correct answer'),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _correctAnswer = newValue;
                      _checkFormValidity();
                    });
                  },
                  items: _optionControllers
                      .map((controller) => controller.text.trim())
                      .where((option) => option.isNotEmpty)
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _explanationController,
                decoration: InputDecoration(
                  labelText: 'Enter explanation',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3, // Allow multiline explanation
                onChanged: (_) => _checkFormValidity(),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _isSaveEnabled ? _addQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSaveEnabled ? Colors.green : Colors.grey,
                  ),
                  child: Text('Save Question'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
