import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/career_bloc.dart';

class CareerDetailScreen extends StatefulWidget {
  final String categoryId;
  final String subCareerId;
  const CareerDetailScreen({super.key, required this.categoryId, required this.subCareerId});

  @override
  State<CareerDetailScreen> createState() => _CareerDetailScreenState();
}

class _CareerDetailScreenState extends State<CareerDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CareerBloc>().add(SubCareerSelected(widget.categoryId, widget.subCareerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CareerBloc, CareerState>(
        builder: (context, state) {
          if (state is CareerDetailLoaded) {
            final career = state.subCareer;
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, career.title),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Overview'),
                        const SizedBox(height: 12),
                        Text(career.overview, style: const TextStyle(fontSize: 16, height: 1.5)),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Required Skills'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: career.skills.map(_buildSkillChip).toList(),
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Core Subjects'),
                        const SizedBox(height: 12),
                        Text(career.subjects.join(', '), style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 32),
                        _buildInfoCard('Entrance Exams', career.entranceExams.join(', '), Icons.assignment),
                        const SizedBox(height: 16),
                        _buildInfoCard('Salary Range', career.salaryRange, Icons.payments),
                        const SizedBox(height: 16),
                        _buildInfoCard('Top Colleges', career.topColleges.join(', '), Icons.account_balance),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String title) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(title),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withAlpha(179)], // 0.7 * 255 ≈ 179
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.work_outline, size: 80, color: Colors.white24),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill),
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
