import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/providers/plan_provider.dart';
import '../../routes/route_names.dart';

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});

  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen> {
  int _phase = 0;

  final phases = const [
    'تحليل المجال والجمهور...',
    'بناء أفكار المحتوى والإعلانات...',
    'تجهيز الجدول والهاشتاقات...',
  ];

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    context.read<PlanProvider>().setLoading(true);

    for (int i = 0; i < phases.length; i++) {
      setState(() => _phase = i);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    context.read<PlanProvider>().setLoading(false);
    context.read<PlanProvider>().generateLocalPlan();

    if (!mounted) return;
    context.read<PlanProvider>().generateLocalPlan();

    Navigator.pushReplacementNamed(context, RouteNames.generatedPlan);
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<PlanProvider>().loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Smart AI')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                const SizedBox(
                  height: 42,
                  width: 42,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              const SizedBox(height: 18),
              Text(
                phases[_phase],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text('بعد ثواني بنعرض لك خطة جاهزة…'),
            ],
          ),
        ),
      ),
    );
  }
}
