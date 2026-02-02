import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../state/providers/brand_provider.dart';
import '../../../state/providers/plan_provider.dart';
import '../../routes/route_names.dart';

class GeneratedPlanScreen extends StatelessWidget {
  const GeneratedPlanScreen({super.key});

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم النسخ ✅')),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    VoidCallback? onCopy,
  }) {
    return Card(
      elevation: 0.6,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                if (onCopy != null)
                  IconButton(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy),
                    tooltip: 'نسخ',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlanProvider>();
    final input = provider.currentInput;
    final basePlan = provider.generated;
    final ai = provider.aiPlan;

    if (input == null || basePlan == null) {
      return const Scaffold(
        body: Center(child: Text('لا يوجد بيانات')),
      );
    }

    // ✅ لو AI موجود استخدمه، وإلا استخدم الخطة المحلية
    final ideas = ai?.contentIdeas ?? basePlan.contentIdeas;
    final ads = ai?.adCopies ?? basePlan.adCopies;
    final tags = ai?.hashtags ?? basePlan.hashtags;
    final cal = ai?.weeklyCalendar ?? basePlan.weeklyCalendar;
    final budgetText = ai != null
        ? '${ai.budgetPlan}\n\nKPI:\n- ${ai.kpis.join('\n- ')}'
        : basePlan.budgetSuggestion;

    final ideasText = ideas.map((e) => '• $e').join('\n');
    final adsText = ads.map((e) => '• $e').join('\n\n');
    final tagsText = tags.join(' ');
    final calText = cal.entries.map((e) => '${e.key}: ${e.value}').join('\n');

    final allText = '''
📌 ${input.businessName}
المجال: ${input.category}
الهدف: ${input.goal}
المنصة: ${input.platform}
الجمهور: ${input.audience}
الميزانية: ${input.budgetLevel}

====================

${ai != null ? "✨ الخطة المحسّنة بالذكاء الاصطناعي" : "✅ الخطة الأساسية"}

====================

✅ أفكار المحتوى:
$ideasText

====================

✅ نصوص الإعلانات:
$adsText

====================

✅ الهاشتاقات:
$tagsText

====================

✅ جدول النشر:
$calText

====================

✅ الميزانية و KPI:
$budgetText
''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('الخطة الناتجة'),
        actions: [
          IconButton(
            onPressed: () => _copy(context, allText),
            icon: const Icon(Icons.copy_all),
            tooltip: ai != null ? 'نسخ الخطة المحسّنة كاملة' : 'نسخ الخطة كاملة',
          ),
          IconButton(
            onPressed: provider.loading
                ? null
                : () async {
                    final brandPath = context.read<BrandProvider>().brandImagePath;
                    final id = await context.read<PlanProvider>().saveCurrentPlan(
                          brandImagePath: brandPath,
                        );

                    if (!context.mounted) return;

                    if (id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('لا يمكن الحفظ: البيانات غير مكتملة')),
                      );
                      return;
                    }

                    final savedAi = context.read<PlanProvider>().hasAiPlan;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(savedAi ? 'تم حفظ الخطة المحسّنة ✅' : 'تم حفظ الخطة ✅')),
                    );

                    // ✅ روح لتبويب "الخطط"
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteNames.main,
                      (_) => false,
                      arguments: 1,
                    );
                  },
            icon: const Icon(Icons.save),
            tooltip: 'حفظ',
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              // معلومات المشروع
              Card(
                elevation: 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        input.businessName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('المجال: ${input.category}')),
                          Chip(label: Text('الهدف: ${input.goal}')),
                          Chip(label: Text('المنصة: ${input.platform}')),
                          Chip(label: Text('الميزانية: ${input.budgetLevel}')),
                          if (ai != null) const Chip(label: Text('✨ AI محسّنة')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('الجمهور: ${input.audience}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ✅ AI Upgrade Card
              Card(
                elevation: 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ai != null ? 'تم تحسين الخطة بالذكاء الاصطناعي ✅' : '✨ ترقية الخطة بالذكاء الاصطناعي',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ai != null
                            ? (ai.headline.isNotEmpty ? ai.headline : 'جاهز! يمكنك الآن نسخها أو حفظها.')
                            : 'سيقوم الذكاء الاصطناعي بتحسين الأفكار والإعلانات والهاشتاقات والتقويم بناءً على بيانات مشروعك.',
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: provider.loading
                            ? null
                            : () async {
                                try {
                                  await context.read<PlanProvider>().improvePlanWithGemini();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('تم إنشاء خطة محسّنة بالذكاء الاصطناعي ✅')),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('خطأ: $e')),
                                  );
                                }
                              },
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(ai != null ? 'إعادة تحسين الخطة' : 'تحسين الخطة بالذكاء الاصطناعي'),
                      ),
                    ],
                  ),
                ),
              ),

              _sectionCard(
                title: 'أفكار محتوى جاهزة (${ideas.length})',
                onCopy: () => _copy(context, ideasText),
                child: Text(ideasText),
              ),

              _sectionCard(
                title: 'نصوص إعلانات قصيرة (${ads.length})',
                onCopy: () => _copy(context, adsText),
                child: Text(adsText),
              ),

              _sectionCard(
                title: 'هاشتاقات مقترحة',
                onCopy: () => _copy(context, tagsText),
                child: Text(tagsText),
              ),

              _sectionCard(
                title: 'جدول نشر أسبوعي',
                onCopy: () => _copy(context, calText),
                child: Text(calText),
              ),

              _sectionCard(
                title: 'الميزانية و KPI',
                onCopy: () => _copy(context, budgetText),
                child: Text(budgetText),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.calendar,
                        arguments: cal, // ✅ يفتح تقويم AI لو موجود
                      ),
                      child: const Text('عرض التقويم'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, RouteNames.main, arguments: 1),
                      child: const Text('الذهاب للخطط'),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ✅ Loading overlay
          if (provider.loading)
            Container(
              color: Colors.black.withOpacity(0.25),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          'جاري إنشاء الخطة بالذكاء الاصطناعي…',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
