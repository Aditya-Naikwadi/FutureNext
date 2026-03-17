import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:futurenext/domain/services/assessment_service.dart';
import 'package:futurenext/data/models/assessment_model.dart';
import 'package:futurenext/data/models/quiz_model.dart';
import 'package:futurenext/data/local/static_quiz_questions.dart';

// Events
abstract class QuizEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuizStarted extends QuizEvent {}
class QuizAnswerSelected extends QuizEvent {
  final QuizOption option;
  QuizAnswerSelected(this.option);
}
class QuizRestarted extends QuizEvent {}

// States
abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  final String message;
  const QuizLoading({this.message = 'Loading...'});
  @override
  List<Object?> get props => [message];
}

class QuizInProgress extends QuizState {
  final String text;
  final List<String> options;
  final int questionCount;
  final List<String> userAnswers;
  final List<Question> sessionQuestions;

  const QuizInProgress({
    required this.text,
    this.options = const [],
    this.questionCount = 0,
    this.userAnswers = const [],
    required this.sessionQuestions,
  });

  @override
  List<Object?> get props => [text, options, questionCount, userAnswers, sessionQuestions];
}

class QuizResult extends QuizState {
  final AssessmentResults results;
  const QuizResult(this.results);
  @override
  List<Object?> get props => [results];
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);
  @override
  List<Object?> get props => [message];
}

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final AssessmentService _assessmentService;

  QuizBloc(this._assessmentService) : super(QuizInitial()) {
    on<QuizStarted>((event, emit) {
      final allQuestions = List<Question>.from(StaticQuizQuestions.pool);
      allQuestions.shuffle();
      final sessionQuestions = allQuestions.take(10).toList();
      
      final firstQuestion = sessionQuestions[0];
      emit(QuizInProgress(
        text: firstQuestion.text,
        options: firstQuestion.options.map((o) => o.text).toList(),
        questionCount: 1,
        userAnswers: const [],
        sessionQuestions: sessionQuestions,
      ));
    });

    on<QuizAnswerSelected>((event, emit) async {
      final currentState = state;
      if (currentState is QuizInProgress) {
        final List<String> updatedAnswers = List.from(currentState.userAnswers)..add(event.option.text);
        
        if (updatedAnswers.length >= 10) {
          emit(const QuizLoading(message: "Analyzing your career path..."));
          try {
            final results = await _assessmentService.analyzeBatch(updatedAnswers);
            emit(QuizResult(results));
          } catch (e) {
            emit(QuizError(e.toString()));
          }
        } else {
          final nextQuestionIndex = updatedAnswers.length;
          final nextQuestion = currentState.sessionQuestions[nextQuestionIndex];
          
          emit(QuizInProgress(
            text: nextQuestion.text,
            options: nextQuestion.options.map((o) => o.text).toList(),
            questionCount: nextQuestionIndex + 1,
            userAnswers: updatedAnswers,
            sessionQuestions: currentState.sessionQuestions,
          ));
        }
      }
    });

    on<QuizRestarted>((event, emit) {
      add(QuizStarted());
    });
  }
}
