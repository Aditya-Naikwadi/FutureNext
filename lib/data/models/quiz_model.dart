import 'package:equatable/equatable.dart';
import 'package:futurenext/data/models/career_model.dart';

class Question extends Equatable {
  final String id;
  final String text;
  final List<QuizOption> options;

  const Question({
    required this.id,
    required this.text,
    required this.options,
  });

  @override
  List<Object?> get props => [id, text, options];
}

class QuizOption extends Equatable {
  final String text;
  final Map<CareerCategoryType, double> scores;

  const QuizOption({
    required this.text,
    required this.scores,
  });

  @override
  List<Object?> get props => [text, scores];
}
