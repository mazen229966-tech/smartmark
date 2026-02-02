class AiPlan {
  final List<String> contentIdeas;
  final List<String> adCopies;
  final List<String> hashtags;
  final Map<String, String> weeklyCalendar;
  final String budgetPlan;
  final List<String> kpis;
  final String headline;

  const AiPlan({
    required this.headline,
    required this.contentIdeas,
    required this.adCopies,
    required this.hashtags,
    required this.weeklyCalendar,
    required this.budgetPlan,
    required this.kpis,
  });
}
