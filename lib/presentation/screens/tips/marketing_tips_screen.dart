import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/providers/tips_provider.dart';

class MarketingTipsScreen extends StatelessWidget {
  const MarketingTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = context.watch<TipsProvider>();

    final categories = const ['مطعم', 'ملابس', 'عطور', 'خدمات', 'متجر إلكتروني'];
    final list = tips.filtered;
    final favs = tips.favoriteList;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نصائح تسويقية ذكية'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'حسب المجال'),
              Tab(text: 'المفضلة ⭐'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // تبويب: حسب المجال
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: tips.selectedCategory,
                        items: categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => tips.setCategory(v!),
                        decoration: const InputDecoration(
                          labelText: 'اختر المجال',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        textAlign: TextAlign.right,
                        onChanged: tips.setQuery,
                        decoration: const InputDecoration(
                          labelText: 'ابحث داخل النصائح…',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text('لا توجد نتائج'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            final t = list[i];
                            final isFav = tips.favorites.contains(t.id);

                            return Card(
                              child: ListTile(
                                title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(t.body),
                                trailing: IconButton(
                                  icon: Icon(isFav ? Icons.star : Icons.star_border),
                                  onPressed: () async {
                                    await context.read<TipsProvider>().toggleFavorite(t.id);
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(isFav ? 'تمت الإزالة من المفضلة' : 'تمت الإضافة للمفضلة ⭐')),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),

            // تبويب: المفضلة
            favs.isEmpty
                ? const Center(child: Text('لا توجد نصائح مفضلة بعد ⭐'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: favs.length,
                    itemBuilder: (context, i) {
                      final t = favs[i];
                      return Card(
                        child: ListTile(
                          title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(t.body),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await context.read<TipsProvider>().toggleFavorite(t.id);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تمت الإزالة من المفضلة')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
