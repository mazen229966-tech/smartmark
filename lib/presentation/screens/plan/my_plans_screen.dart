import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/providers/plan_provider.dart';
import '../../routes/route_names.dart';

import 'dart:io';

class MyPlansScreen extends StatefulWidget {
  const MyPlansScreen({super.key});

  @override
  State<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen> {
  final _search = TextEditingController();
  String _q = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PlanProvider>().loadPlans());
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlanProvider>();
    final list = provider.searchPlans(_q);

    return Scaffold(
      appBar: AppBar(title: const Text('خططي السابقة')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'ابحث باسم المشروع أو المجال…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : list.isEmpty
                    ? const Center(
                        child: Text('لا توجد خطط محفوظة بعد.\nأنشئ أول خطة من الصفحة الرئيسية ✨', textAlign: TextAlign.center),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final p = list[i];
                          return Card(
  child: ListTile(
    leading: (p.brandImagePath != null && p.brandImagePath!.isNotEmpty)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(p.brandImagePath!),
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
            ),
          )
        : const Icon(Icons.photo, size: 32),
    title: Text(
      p.businessName,
      textAlign: TextAlign.right,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      '${p.category} • ${p.goal} • ${p.platform}',
      textAlign: TextAlign.right,
    ),
    trailing: const Icon(Icons.chevron_left),
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteNames.planDetails,
        arguments: p.id,
      );
    },
  ),
);

                        },
                      ),
          ),
        ],
      ),
    );
  }
}
