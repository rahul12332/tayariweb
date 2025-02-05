import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddQuestionScreen extends StatefulWidget {
  final String subjectName;
  final String mockName;

  AddQuestionScreen({required this.subjectName, required this.mockName});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController _explanationController = TextEditingController();
  String? _correctAnswer;
  bool _isSaveEnabled = false;

  // OpenAI API Key (Replace with your own secret key)
  final String openAiApiKey = "sk-...uWAA";

  // Function to check form validity
  void _checkFormValidity() {
    setState(() {
      _isSaveEnabled = _questionController.text.isNotEmpty &&
          _optionControllers
              .every((controller) => controller.text.isNotEmpty) &&
          _correctAnswer != null &&
          _explanationController.text.isNotEmpty;
    });
  }

  // Function to call OpenAI API using Dio
  Future<void> _generateQuestion() async {
    setState(() {
      _questionController.text = "Generating question...";
      _explanationController.text = "Generating explanation...";
      for (var controller in _optionControllers) {
        controller.text = "Generating option...";
      }
    });

    Dio dio = Dio();

    try {
      final response = await dio.post(
        "https://api.openai.com/v1/chat/completions",
        options: Options(
          headers: {
            "Authorization": "Bearer $openAiApiKey",
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an AI that generates multiple-choice questions."
            },
            {
              "role": "user",
              "content":
                  "Generate a multiple-choice question with 4 options, the correct answer, and a brief explanation for ${widget.subjectName} - ${widget.mockName}."
            }
          ],
          "max_tokens": 200,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final generatedText = jsonResponse["choices"][0]["message"]["content"];

        // Extract data (assuming JSON format from AI)
        final extractedData = jsonDecode(generatedText);

        setState(() {
          _questionController.text = extractedData["question"];
          for (int i = 0; i < 4; i++) {
            _optionControllers[i].text = extractedData["options"][i];
          }
          _correctAnswer = extractedData["correct_answer"];
          _explanationController.text = extractedData["explanation"];
          _checkFormValidity();
        });
      } else {
        throw Exception("Failed to fetch question");
      }
    } catch (e) {
      setState(() {
        _questionController.text = "Error generating question";
        _explanationController.text = "Error generating explanation";
        for (var controller in _optionControllers) {
          controller.text = "Error";
        }
      });
      print("Error: $e");
    }
  }

  // Function to save the question
  void _addQuestion() {
    // Implement your save logic here
    print("Question Saved: ${_questionController.text}");
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
              // Generate AI Question Button
              ElevatedButton(
                onPressed: _generateQuestion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Generate AI Question'),
              ),
              SizedBox(height: 16),

              // Question Input
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

              // Options Input Fields
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

              // Dropdown for Correct Answer
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

              // Explanation Input
              TextFormField(
                controller: _explanationController,
                decoration: InputDecoration(
                  labelText: 'Enter explanation',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (_) => _checkFormValidity(),
              ),

              SizedBox(height: 20),

              // Save Button
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
