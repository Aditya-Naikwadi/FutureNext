import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/quiz_model.dart';
import '../../data/static/quiz_data.dart';
import '../../data/models/career_model.dart';
import '../../data/static/career_data.dart';

// Events
abstract class QuizEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuizStarted extends QuizEvent {
  final bool isFollowUp;
  QuizStarted({this.isFollowUp = false});
}

class QuizAnswerSelected extends QuizEvent {
  final int questionIndex;
  final QuizOption option;
  QuizAnswerSelected(this.questionIndex, this.option);
}

class QuizSubmitted extends QuizEvent {}

class QuizReset extends QuizEvent {}

// States
abstract class QuizState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizInProgress extends QuizState {
  final int currentQuestionIndex;
  final List<QuizQuestion> questions;
  final Map<int, QuizOption> answers;
  final bool isFollowUp;

  QuizInProgress({
    required this.currentQuestionIndex,
    required this.questions,
    required this.answers,
    this.isFollowUp = false,
  });

  @override
  List<Object?> get props => [currentQuestionIndex, questions, answers, isFollowUp];
}

class QuizResultsReady extends QuizState {
  final List<MapEntry<CareerCategory, double>> topRecommendations;
  QuizResultsReady(this.topRecommendations);

  @override
  List<Object?> get props => [topRecommendations];
}

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<QuizStarted>((event, emit) {
      final questions = event.isFollowUp ? QuizData.followUpQuestions : QuizData.mainProgressQuestions;
      emit(QuizInProgress(
        currentQuestionIndex: 0,
        questions: questions,
        answers: {},
        isFollowUp: event.isFollowUp,
      ));
    });

    on<QuizAnswerSelected>((event, emit) {
      if (state is QuizInProgress) {
        final currentState = state as QuizInProgress;
        final newAnswers = Map<int, QuizOption>.from(currentState.answers);
        newAnswers[event.questionIndex] = event.option;

        if (event.questionIndex < currentState.questions.length - 1) {
          emit(QuizInProgress(
            currentQuestionIndex: event.questionIndex + 1,
            questions: currentState.questions,
            answers: newAnswers,
            isFollowUp: currentState.isFollowUp,
          ));
        } else {
          emit(QuizInProgress(
            currentQuestionIndex: event.questionIndex,
            questions: currentState.questions,
            answers: newAnswers,
            isFollowUp: currentState.isFollowUp,
          ));
          add(QuizSubmitted());
        }
      }
    });

    on<QuizSubmitted>((event, emit) {
      if (state is QuizInProgress) {
        final currentState = state as QuizInProgress;
        final results = _calculateResults(currentState.answers.values.toList());
        emit(QuizResultsReady(results));
      }
    });

    on<QuizReset>((event, emit) {
      emit(QuizInitial());
    });
  }

  List<MapEntry<CareerCategory, double>> _calculateResults(List<QuizOption> answers) {
    final Map<String, int> scores = {};

    for (var answer in answers) {
      answer.careerWeights.forEach((key, value) {
        scores[key] = (scores[key] ?? 0) + value;
      });
    }

    // Map scores to categories
    final List<MapEntry<CareerCategory, double>> categoryScores = [];
    int maxScore = 0;
    
    for (var cat in CareerData.categories) {
      final score = scores[cat.id] ?? 0;
      if (score > maxScore) maxScore = score;
      categoryScores.add(MapEntry(cat, score.toDouble()));
    }

    // Normalize to percentages (roughly)
    final results = categoryScores.map((entry) {
      final percentage = maxScore > 0 ? (entry.value / maxScore) * 100 : 0.0;
      return MapEntry(entry.key, percentage);
    }).toList();

    results.sort((a, b) => b.value.compareTo(a.value));
    return results.take(3).toList();
  }
}
