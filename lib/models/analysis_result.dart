class SectionScore {
  final String name;
  final int score;
  final String feedback;

  SectionScore({
    required this.name,
    required this.score,
    required this.feedback,
  });

  factory SectionScore.fromJson(String name, Map<String, dynamic> json) {
    return SectionScore(
      name: name,
      score: (json['score'] as num).toInt(),
      feedback: json['feedback'] as String? ?? '',
    );
  }
}

class AnalysisResult {
  final int overallScore;
  final List<SectionScore> sections;
  final List<String> recommendations;

  AnalysisResult({
    required this.overallScore,
    required this.sections,
    required this.recommendations,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    final sectionsMap = json['sections'] as Map<String, dynamic>? ?? {};
    final sections = sectionsMap.entries
        .map((e) => SectionScore.fromJson(e.key, e.value as Map<String, dynamic>))
        .toList();

    final recs = (json['recommendations'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return AnalysisResult(
      overallScore: (json['overallScore'] as num?)?.toInt() ?? 0,
      sections: sections,
      recommendations: recs,
    );
  }
}
