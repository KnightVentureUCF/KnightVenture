import 'package:flutter/material.dart';
import 'package:frontend/models/caches.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:frontend/widgets/dataprovider/data_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class QuizPopup extends StatelessWidget {
  final Cache cache;
  final String accessToken;
  final String username;
  final void Function() exitCacheNavigation;

  const QuizPopup(
      {super.key,
      required this.cache,
      required this.accessToken,
      required this.username,
      required this.exitCacheNavigation});

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
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: _QuestionWidget(
                    cache: cache,
                    accessToken: accessToken,
                    username: username,
                    exitCacheNavigation: exitCacheNavigation,
                  ),
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
  final String accessToken;
  final String username;
  final void Function() exitCacheNavigation;

  const _QuestionWidget(
      {required this.cache,
      required this.accessToken,
      required this.username,
      required this.exitCacheNavigation});

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

  void _checkAnswer(String selectedAnswer, DataProvider dataProvider) {
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
      _showResults(dataProvider);
    }
  }

  Future<void> _showResults(DataProvider dataProvider) async {
    if (correctAnswersCount == widget.cache.questions!.length) {
      // Call the API to confirm the cache find
      String cacheId = widget.cache.id;
      String username = widget.username; // Use the passed username
      String accessToken = widget.accessToken; // Use the passed accessToken
      int points = widget.cache.points ?? 0;

      widget.exitCacheNavigation();
      dataProvider.confirmCacheFind(cacheId, points, username, accessToken, context, this.context);
    } else {
      // Show quiz results without cache confirmation
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
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final question = widget.cache.questions![currentQuestionIndex];

    return Container(
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
                  _checkAnswer(answer, dataProvider);
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
