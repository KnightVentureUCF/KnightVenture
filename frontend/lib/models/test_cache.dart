class Question {
  final String questionText;
  final List<String> answers;

  Question({
    required this.questionText,
    required this.answers,
  }) : assert(answers.length == 4,
            'Each question must have 4 answers'); // Ensures 4 answers
}

class TestCache {
  const TestCache({
    required this.name,
    required this.desc,
    required this.icon,
    required this.imgUrl,
    required this.lat,
    required this.lng,
    this.questions, // Optional questions field
  });

  final String name;
  final String desc;
  final String icon;
  final String imgUrl;
  final double lat;
  final double lng;
  final List<Question>? questions; // Nullable List of questions
}
