class GeneratedPlan {
  final List<String> contentIdeas;
  final List<String> adCopies;
  final List<String> hashtags;
  final Map<String, String> weeklyCalendar; // اليوم -> نوع المحتوى
  final String budgetSuggestion;

  const GeneratedPlan({
    required this.contentIdeas,
    required this.adCopies,
    required this.hashtags,
    required this.weeklyCalendar,
    required this.budgetSuggestion,
  });

  Map<String, dynamic> toJson() => {
        'contentIdeas': contentIdeas,
        'adCopies': adCopies,
        'hashtags': hashtags,
        'weeklyCalendar': weeklyCalendar,
        'budgetSuggestion': budgetSuggestion,
      };

  factory GeneratedPlan.fromJson(Map<String, dynamic> json) {
    return GeneratedPlan(
      contentIdeas: List<String>.from(json['contentIdeas'] ?? const []),
      adCopies: List<String>.from(json['adCopies'] ?? const []),
      hashtags: List<String>.from(json['hashtags'] ?? const []),
      weeklyCalendar: Map<String, String>.from(json['weeklyCalendar'] ?? const {}),
      budgetSuggestion: (json['budgetSuggestion'] ?? '').toString(),
    );
  }
}
