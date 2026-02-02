import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/providers/plan_provider.dart';

class ContentCalendarScreen extends StatelessWidget {
  const ContentCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;

    // ✅ إذا جتنا خريطة تقويم من Details نستخدمها
    Map<String, String>? calendar;
    if (arg is Map<String, String>) {
      calendar = arg;
    }

    // ✅ fallback: آخر خطة مولدة
    calendar ??= context.watch<PlanProvider>().generated?.weeklyCalendar;

    return Scaffold(
      appBar: AppBar(title: const Text('تقويم المحتوى')),
      body: calendar == null || calendar.isEmpty
          ? const Center(child: Text('لا يوجد تقويم حالياً'))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: calendar.entries.map((e) {
                return Card(
                  child: ListTile(
                    title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(e.value),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
