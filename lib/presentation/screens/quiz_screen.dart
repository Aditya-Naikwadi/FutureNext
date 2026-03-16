import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/quiz_bloc.dart';
import '../../data/models/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(QuizStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personality Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizResultsReady) {
            context.pushReplacement('/quiz-results', extra: state.topRecommendations);
          }
        },
        builder: (context, state) {
          if (state is QuizInProgress) {
            final progress = (state.currentQuestionIndex + 1) / state.questions.length;
            final question = state.questions[state.currentQuestionIndex];

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                   ),
                   const SizedBox(height: 16),
                   Text(
                    'Question ${state.currentQuestionIndex + 1}/${state.questions.length}',
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(height: 32),
                   Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.question,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D3142),
                                ),
                          ),
                          const SizedBox(height: 32),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: question.options.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final option = question.options[index];
                              return _buildOptionCard(context, option, state.currentQuestionIndex);
                            },
                          ),
                        ],
                      ),
                    ),
                   ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, QuizOption option, int index) {
    return InkWell(
      onTap: () {
        context.read<QuizBloc>().add(QuizAnswerSelected(index, option));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.text,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
