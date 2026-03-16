import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<QuizOption> options;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  @override
  List<Object?> get props => [id, question, options];
}

class QuizOption extends Equatable {
  final String text;
  final Map<String, int> careerWeights; // e.g., {'tech': 3, 'arts': 1}

  const QuizOption({
    required this.text,
    required this.careerWeights,
  });

  @override
  List<Object?> get props => [text, careerWeights];
}
