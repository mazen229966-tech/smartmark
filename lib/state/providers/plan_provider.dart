import 'package:flutter/material.dart';

import '../../data/generators/plan_generator.dart';
import '../../data/local/db/db_helper.dart';
import '../../data/models/generated_plan.dart';
import '../../data/models/marketing_plan.dart';
import '../../data/models/plan_input.dart';

// ✅ Gemini AI
import '../../data/models/ai_plan.dart';
import '../../data/parsers/ai_plan_parser.dart';
import '../../data/remote/gemini_api_service.dart';

class PlanProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  PlanInput? _currentInput;
  PlanInput? get currentInput => _currentInput;

  GeneratedPlan? _generated;
  GeneratedPlan? get generated => _generated;

  // ✅ AI improved plan
  AiPlan? _aiPlan;
  AiPlan? get aiPlan => _aiPlan;
  bool get hasAiPlan => _aiPlan != null;

  List<MarketingPlan> _plans = [];
  List<MarketingPlan> get plans => _plans;

  void setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void setCurrentInput(PlanInput input) {
    _currentInput = input;
    notifyListeners();
  }

  void generateLocalPlan() {
    if (_currentInput == null) return;
    _generated = PlanGenerator.generate(_currentInput!);

    // ✅ عند توليد خطة جديدة، امسح AI السابقة
    _aiPlan = null;

    notifyListeners();
  }

  /// ✅ تحسين الخطة كاملة بالذكاء الاصطناعي (Gemini)
  Future<void> improvePlanWithGemini() async {
    if (_currentInput == null) return;

    setLoading(true);
    try {
      final raw = await GeminiApiService.improveFullPlan(
        businessName: _currentInput!.businessName,
        category: _currentInput!.category,
        goal: _currentInput!.goal,
        platform: _currentInput!.platform,
        audience: _currentInput!.audience,
        budgetLevel: _currentInput!.budgetLevel,
      );

      _aiPlan = AiPlanParser.parse(raw);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadPlans() async {
    setLoading(true);
    try {
      _plans = await DbHelper.instance.getAllPlans();
    } finally {
      setLoading(false);
    }
  }

  /// ✅ حفظ الخطة الحالية
  /// إذا في AI plan موجودة -> يحفظ النسخة المحسّنة
  Future<int?> saveCurrentPlan({String? brandImagePath}) async {
    if (_currentInput == null) return null;
    if (_generated == null && _aiPlan == null) return null;

    setLoading(true);
    try {
      // ✅ لو فيه AI plan نحولها لـ GeneratedPlan عشان نخزنها في DB بنفس الموديل الحالي
      final GeneratedPlan usedPlan = (_aiPlan != null)
          ? GeneratedPlan(
              contentIdeas: _aiPlan!.contentIdeas,
              adCopies: _aiPlan!.adCopies,
              hashtags: _aiPlan!.hashtags,
              weeklyCalendar: _aiPlan!.weeklyCalendar,
              budgetSuggestion:
                  '${_aiPlan!.budgetPlan}\n\nKPI:\n- ${_aiPlan!.kpis.join('\n- ')}',
            )
          : _generated!;

      final plan = MarketingPlan.fromInput(
        input: _currentInput!,
        plan: usedPlan,
        brandImagePath: brandImagePath,
      );

      final id = await DbHelper.instance.insertPlan(plan);
      await loadPlans();
      return id;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deletePlan(int id) async {
    setLoading(true);
    try {
      await DbHelper.instance.deletePlan(id);
      await loadPlans();
    } finally {
      setLoading(false);
    }
  }

  Future<void> clearAllPlansFromDb() async {
    setLoading(true);
    try {
      await DbHelper.instance.clearPlans();
      await loadPlans();
    } finally {
      setLoading(false);
    }
  }

  List<MarketingPlan> searchPlans(String q) {
    final query = q.trim();
    if (query.isEmpty) return _plans;
    return _plans.where((p) {
      return p.businessName.contains(query) ||
          p.category.contains(query) ||
          p.goal.contains(query) ||
          p.platform.contains(query);
    }).toList();
  }

  void clearAllLocalState() {
    _currentInput = null;
    _generated = null;
    _aiPlan = null;
    notifyListeners();
  }
}
