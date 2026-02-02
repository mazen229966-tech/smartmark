import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/local/db/db_helper.dart';
import '../../../data/models/marketing_plan.dart';
import '../../../state/providers/plan_provider.dart';
import '../../routes/route_names.dart';

class PlanDetailsScreen extends StatefulWidget {
  const PlanDetailsScreen({super.key});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  MarketingPlan? _plan;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final id = (arg is int) ? arg : int.tryParse(arg.toString());

    if (id == null) {
      setState(() {
        _loading = false;
        _plan = null;
      });
      return;
    }

    final plan = await DbHelper.instance.getPlanById(id);
    setState(() {
      _plan = plan;
      _loading = false;
    });
  }

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف الخطة؟'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذه الخطة؟'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
          ],
        );
      },
    );

    if (ok != true) return;

    await context.read<PlanProvider>().deletePlan(id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف الخطة ✅')),
    );
    Navigator.pop(context);
  }

  Widget _block(String title, String body) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_plan == null) {
      return const Scaffold(body: Center(child: Text('الخطة غير موجودة')));
    }

    final p = _plan!;
    final ideasText = p.generatedPlan.contentIdeas.map((e) => '• $e').join('\n');
    final adsText = p.generatedPlan.adCopies.map((e) => '• $e').join('\n\n');
    final tagsText = p.generatedPlan.hashtags.join(' ');
    final calText = p.generatedPlan.weeklyCalendar.entries.map((e) => '${e.key}: ${e.value}').join('\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الخطة'),
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(p.id!),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'حذف',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              title: Text(p.businessName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p.category} • ${p.goal} • ${p.platform}\n${p.createdAt}'),
            ),
          ),
          _block('الجمهور', p.audience),
          _block('أفكار المحتوى', ideasText),
          _block('نصوص الإعلانات', adsText),
          _block('الهاشتاقات', tagsText),
          _block('الجدول الأسبوعي', calText),
          _block('اقتراح الميزانية', p.generatedPlan.budgetSuggestion),

          if (p.brandImagePath != null && p.brandImagePath!.isNotEmpty)


  Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          File(p.brandImagePath!),
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(
            height: 200,
            child: Center(child: Text('تعذر عرض الصورة')),
          ),
        ),
      ),
    ),
  ),


  Card(
  child: ListTile(
    title: const Text('عرض تقويم النشر'),
    subtitle: const Text('فتح جدول النشر الأسبوعي لهذه الخطة'),
    trailing: const Icon(Icons.chevron_left),
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteNames.calendar,
        arguments: p.generatedPlan.weeklyCalendar, // ✅ تقويم الخطة المحفوظة
      );
    },
  ),
),


        ],
      ),
    );
  }
}
