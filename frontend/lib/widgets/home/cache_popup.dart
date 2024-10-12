import 'package:flutter/material.dart';
import 'package:frontend/models/caches.dart';

class Quiz extends StatelessWidget {
  final Cache cache;

  const Quiz({Key? key, required this.cache}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return QuizModal(cache: cache);
          },
        );
      },
      child: Text('Start Quiz'),
    );
  }
}

class QuizModal extends StatefulWidget {
  final Cache cache;

  const QuizModal({Key? key, required this.cache}) : super(key: key);

  @override
  _QuizModalState createState() => _QuizModalState();
}

class _QuizModalState extends State<QuizModal> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    final questions = widget.cache.questions ?? [];

    if (_currentQuestionIndex >= questions.length) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Quiz Completed!'),
            Text('Your score: $_score/${questions.length}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }

    final question = questions[_currentQuestionIndex];
    final shuffledAnswers = question.getShuffledAnswers();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(question.text),
          ...shuffledAnswers.map((answer) {
            return ListTile(
              title: Text(answer),
              onTap: () {
                setState(() {
                  if (answer == question.answers[0]) {
                    _score++;
                  }
                  _currentQuestionIndex++;
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
