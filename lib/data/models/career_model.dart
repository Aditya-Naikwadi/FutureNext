import 'package:equatable/equatable.dart';

enum CareerCategoryType {
  technology,
  science,
  medicine,
  arts,
  commerce,
  law,
  education,
  media,
  sports,
  hospitality,
  agriculture,
  design,
  socialWork,
  aviation,
  maritime,
  defense,
  performingArts,
  architecture,
  environmentalScience,
  linguistics,
  psychology,
}

class CareerCategory extends Equatable {
  final String id;
  final CareerCategoryType type;
  final String title;
  final String icon;
  final String description;
  final List<SubCareer> subCareers;

  const CareerCategory({
    required this.id,
    required this.type,
    required this.title,
    required this.icon,
    required this.description,
    required this.subCareers,
  });

  @override
  List<Object?> get props => [id, type, title, icon, description, subCareers];
}

class SubCareer extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String matchPercentage;
  final String overview;
  final List<String> skills;
  final List<String> subjects;
  final List<String> entranceExams;
  final String salaryRange;
  final List<String> topColleges;

  const SubCareer({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.matchPercentage = '0%',
    required this.overview,
    required this.skills,
    required this.subjects,
    required this.entranceExams,
    required this.salaryRange,
    required this.topColleges,
  });

  @override
  List<Object?> get props => [id, title, description, icon, matchPercentage, overview, skills, subjects, entranceExams, salaryRange, topColleges];
}
