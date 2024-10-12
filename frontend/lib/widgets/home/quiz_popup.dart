import 'package:flutter/material.dart';
import 'package:frontend/models/caches.dart';

class QuizPopup extends StatelessWidget {
  final Cache cache;

  const QuizPopup({super.key, required this.cache});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 36),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.7,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: _QuestionWidget(cache: cache),
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow,
        ),
        child: const Text('Start Quiz',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _QuestionWidget extends StatefulWidget {
  final Cache cache;

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

  void _shuffleAnswers() {
    final question = widget.cache.questions![currentQuestionIndex];
    shuffledAnswers = List.from(question.answers);
    shuffledAnswers.shuffle();
  }

  void _checkAnswer(String selectedAnswer) {
    final question = widget.cache.questions![currentQuestionIndex];
    bool isCorrect = (selectedAnswer == question.answers[0]);

    if (isCorrect) {
      correctAnswersCount++;
    }

    if (currentQuestionIndex < widget.cache.questions!.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _shuffleAnswers();
      });
    } else {
      _showResults();
    }
  }

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
                Navigator.pop(context);
                Navigator.of(this.context).pop();
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
      color: Colors.black,
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
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              question.text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ...shuffledAnswers.map((answer) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  _checkAnswer(answer);
                },
                child: Text(
                  answer,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          Text(
            'Question ${currentQuestionIndex + 1} of ${widget.cache.questions!.length}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
