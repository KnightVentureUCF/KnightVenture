import 'package:flutter/material.dart';
import 'dart:math'; // For shuffling the answers
import 'package:frontend/models/test_cache.dart';

class CachePopup {
  static void show(BuildContext context, TestCache cache) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .7,
          child: _QuestionWidget(cache: cache),
        );
      },
    );
  }
}

class _QuestionWidget extends StatefulWidget {
  final TestCache cache;

  const _QuestionWidget({required this.cache});

  @override
  State<_QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<_QuestionWidget> {
  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;
  late List<String> shuffledAnswers;

  @override
  void initState() {
    super.initState();
    _shuffleAnswers();
  }

  // Shuffle the answers for the current question
  void _shuffleAnswers() {
    final question = widget.cache.questions![currentQuestionIndex];
    shuffledAnswers = List.from(question.answers); // Copy the list of answers
    shuffledAnswers.shuffle(); // Shuffle them
  }

  // Check if the selected answer is correct
  void _checkAnswer(String selectedAnswer) {
    final question = widget.cache.questions![currentQuestionIndex];
    // The first answer in the original list is always the correct one
    bool isCorrect = (selectedAnswer == question.answers[0]);

    if (isCorrect) {
      correctAnswersCount++;
    }

    // Move to the next question or show the result
    if (currentQuestionIndex < widget.cache.questions!.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _shuffleAnswers(); // Shuffle answers for the next question
      });
    } else {
      _showResults();
    }
  }

  // Show the result at the end
  void _showResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Complete'),
          content: Text(
            'You got $correctAnswersCount out of ${widget.cache.questions!.length} correct!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.of(this.context)
                    .pop(); // Close the modal bottom sheet
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.cache.questions![currentQuestionIndex];

    return Container(
      color: Colors.black, // Set background color to black
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                widget.cache.name,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white, // Set title text color to white
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white, // Set question text color to white
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // Create yellow buttons with black text
          ...shuffledAnswers.map((answer) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.yellow, // Set button background color to yellow
                  foregroundColor:
                      Colors.black, // Set button text color to black
                  minimumSize: const Size.fromHeight(
                      50), // Stretch button to fit horizontally
                ),
                onPressed: () {
                  _checkAnswer(answer); // Check the selected answer
                },
                child: Text(
                  answer,
                  style: const TextStyle(
                      color: Colors.black), // Ensure button text is black
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Text(
            'Question ${currentQuestionIndex + 1} of ${widget.cache.questions!.length}',
            style: const TextStyle(
              color: Colors.white, // Set bottom progress text color to white
            ),
          ),
        ],
      ),
    );
  }
}
