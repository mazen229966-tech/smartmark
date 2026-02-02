import 'dart:convert';
import '../local/db/db_schema.dart';
import 'generated_plan.dart';
import 'plan_input.dart';

class MarketingPlan {
  final int? id;
  final String businessName;
  final String category;
  final String goal;
  final String platform;
  final String audience;
  final String budgetLevel;
  final String? brandImagePath;
  final GeneratedPlan generatedPlan;
  final String createdAt;

  const MarketingPlan({
    this.id,
    required this.businessName,
    required this.category,
    required this.goal,
    required this.platform,
    required this.audience,
    required this.budgetLevel,
    required this.brandImagePath,
    required this.generatedPlan,
    required this.createdAt,
  });

  factory MarketingPlan.fromInput({
    required PlanInput input,
    required GeneratedPlan plan,
    String? brandImagePath,
  }) {
    return MarketingPlan(
      businessName: input.businessName,
      category: input.category,
      goal: input.goal,
      platform: input.platform,
      audience: input.audience,
      budgetLevel: input.budgetLevel,
      brandImagePath: brandImagePath,
      generatedPlan: plan,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() => {
        DbSchema.colId: id,
        DbSchema.colBusinessName: businessName,
        DbSchema.colCategory: category,
        DbSchema.colGoal: goal,
        DbSchema.colPlatform: platform,
        DbSchema.colAudience: audience,
        DbSchema.colBudgetLevel: budgetLevel,
        DbSchema.colBrandImagePath: brandImagePath,
        DbSchema.colPlanJson: jsonEncode(generatedPlan.toJson()),
        DbSchema.colCreatedAt: createdAt,
      };

  factory MarketingPlan.fromMap(Map<String, dynamic> map) {
    return MarketingPlan(
      id: map[DbSchema.colId] as int?,
      businessName: (map[DbSchema.colBusinessName] ?? '').toString(),
      category: (map[DbSchema.colCategory] ?? '').toString(),
      goal: (map[DbSchema.colGoal] ?? '').toString(),
      platform: (map[DbSchema.colPlatform] ?? '').toString(),
      audience: (map[DbSchema.colAudience] ?? '').toString(),
      budgetLevel: (map[DbSchema.colBudgetLevel] ?? '').toString(),
      brandImagePath: map[DbSchema.colBrandImagePath]?.toString(),
      generatedPlan: GeneratedPlan.fromJson(
        jsonDecode((map[DbSchema.colPlanJson] ?? '{}').toString()) as Map<String, dynamic>,
      ),
      createdAt: (map[DbSchema.colCreatedAt] ?? '').toString(),
    );
  }
}
