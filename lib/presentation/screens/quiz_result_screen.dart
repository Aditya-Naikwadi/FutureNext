import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/career_model.dart';
import '../widgets/custom_button.dart';

class QuizResultScreen extends StatelessWidget {
  final List<MapEntry<CareerCategory, double>> results;

  const QuizResultScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Career Matches')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.stars, size: 80, color: Color(0xFFFFD700)),
            const SizedBox(height: 16),
            const Text(
              'Great job!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Based on your answers, here are the top fields where you\'d likely thrive:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ...results.map((entry) => _buildResultCard(context, entry)),
            const SizedBox(height: 32),
            const Text(
              'Still not sure?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Ask AI Guide',
              isSecondary: true,
              onPressed: () => context.push('/chat'),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Back to Dashboard',
              onPressed: () => context.go('/dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, MapEntry<CareerCategory, double> entry) {
    final category = entry.key;
    final percentage = entry.value.toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: entry.value / 100,
            backgroundColor: Colors.grey[100],
            strokeWidth: 6,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '$percentage% Match',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              // Navigate to category list
            },
          ),
        ],
      ),
    );
  }
}
