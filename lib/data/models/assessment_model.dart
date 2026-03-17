class CareerRecommendation {
  final String role;
  final int fitPercentage;
  final String matchTier;
  final int rank;

  CareerRecommendation({
    required this.role,
    required this.fitPercentage,
    required this.matchTier,
    required this.rank,
  });

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      role: json['role'] as String,
      fitPercentage: json['fit'] as int,
      matchTier: json['tier'] as String,
      rank: json['rank'] as int,
    );
  }
}

class AssessmentResults {
  final String domain;
  final List<CareerRecommendation> results;
  final String? topRoleCard;
  final String? roadmap;

  AssessmentResults({
    required this.domain,
    required this.results,
    this.topRoleCard,
    this.roadmap,
  });
}
