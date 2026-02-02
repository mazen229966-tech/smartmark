import 'dart:convert';
import '../models/ai_plan.dart';

class AiPlanParser {
  static AiPlan parse(String raw) {
    // أحيانًا Gemini يرجّع ```json ... ``` فنشيلها
    final cleaned = raw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final map = jsonDecode(cleaned) as Map<String, dynamic>;

    return AiPlan(
      headline: (map['headline'] ?? '').toString(),
      contentIdeas: List<String>.from(map['contentIdeas'] ?? const []),
      adCopies: List<String>.from(map['adCopies'] ?? const []),
      hashtags: List<String>.from(map['hashtags'] ?? const []),
      weeklyCalendar: Map<String, String>.from(map['weeklyCalendar'] ?? const {}),
      budgetPlan: (map['budgetPlan'] ?? '').toString(),
      kpis: List<String>.from(map['kpis'] ?? const []),
    );
  }
}
