class OccupationDetails {
  final String code;
  final String title;
  final String description;
  final List<String> tasks;
  final List<String> skills;
  final List<String> technology;
  final String outlook;
  final String education;
  final String medianSalary;

  OccupationDetails({
    required this.code,
    required this.title,
    required this.description,
    required this.tasks,
    required this.skills,
    required this.technology,
    required this.outlook,
    required this.education,
    required this.medianSalary,
  });

  factory OccupationDetails.fromJson(Map<String, dynamic> json) {
    // Note: O*NET API structure varies slightly depending on endpoint
    // This is a simplified mapper for the FutureNext requirement
    return OccupationDetails(
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tasks: List<String>.from(json['tasks'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      technology: List<String>.from(json['technology'] ?? []),
      outlook: json['outlook'] ?? 'Stable',
      education: json['education'] ?? 'Degree Required',
      medianSalary: json['salary'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'description': description,
      'tasks': tasks,
      'skills': skills,
      'technology': technology,
      'outlook': outlook,
      'education': education,
      'salary': medianSalary,
    };
  }
}
