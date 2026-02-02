import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/local/prefs/prefs_helper.dart';
import '../../../state/providers/brand_provider.dart';
import '../../../state/providers/plan_provider.dart';
import '../../routes/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = 'مستخدم';
  bool _initDone = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_init);
  }

  Future<void> _init() async {
    final name = await PrefsHelper.getUsername();
    if (mounted) {
      setState(() => _username = (name == null || name.trim().isEmpty) ? 'مستخدم' : name.trim());
    }
    await context.read<PlanProvider>().loadPlans();
    if (mounted) setState(() => _initDone = true);
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final brandProvider = context.watch<BrandProvider>();

    final plans = planProvider.plans;
    final count = plans.length;
    final last = plans.isNotEmpty ? plans.first : null;

    final brandFile = brandProvider.brandImageFile;
    final hasBrand = brandProvider.brandImagePath != null && brandProvider.brandImagePath!.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: planProvider.loading && !_initDone
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => context.read<PlanProvider>().loadPlans(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _Header(
                      username: _username,
                      brandFile: brandFile,
                      onBrandTap: () => Navigator.pushNamed(context, RouteNames.brandKit),
                    ),
                    const SizedBox(height: 14),

                    // ✅ Stats: (عدد الخطط + حالة الهوية) بدل (آخر خطة)
                    _StatsRow(
                      plansCount: count,
                      brandStatusTitle: 'هوية المشروع',
                      brandStatusValue: hasBrand ? 'مضاف ✅' : 'غير مضاف',
                      brandStatusSubtitle: hasBrand ? 'سيتم إرفاق الصورة مع الخطط' : 'أضف صورة شعار/منتج',
                      brandStatusIcon: hasBrand ? Icons.verified_outlined : Icons.photo_outlined,
                    ),
                    const SizedBox(height: 14),

                    _SectionTitle(
                      title: 'إجراءات سريعة',
                      subtitle: 'ابدأ بسرعة وبشكل منظم',
                    ),
                    const SizedBox(height: 10),

                    // ✅ حذف Settings من هنا + إضافة "التقويم"
                    _QuickActionsGrid(
                      onCreate: () => Navigator.pushNamed(context, RouteNames.createPlan),
                      onPlans: () => Navigator.pushNamed(context, RouteNames.myPlans),
                      onBrand: () => Navigator.pushNamed(context, RouteNames.brandKit),
                      onTips: () => Navigator.pushNamed(context, RouteNames.tips),
                      onCalendar: () => Navigator.pushNamed(context, RouteNames.calendar),
                    ),
                    const SizedBox(height: 14),

                    _SectionTitle(
                      title: 'آخر خطة',
                      subtitle: last == null ? 'لا توجد خطط محفوظة بعد' : 'تابع من حيث توقفت',
                    ),
                    const SizedBox(height: 10),

                    if (last == null)
                      _EmptyLastPlan(
                        onCreate: () => Navigator.pushNamed(context, RouteNames.createPlan),
                      )
                    else
                      _LastPlanCard(
                        title: last.businessName,
                        meta: '${last.category} • ${last.goal} • ${last.platform}',
                        createdAt: last.createdAt,
                        imagePath: last.brandImagePath,
                        onOpen: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.planDetails,
                            arguments: last.id,
                          );
                        },
                      ),

                    const SizedBox(height: 18),

                    _TipBanner(
                      text: 'نصيحة اليوم: اجعل 70% من محتواك قيمة و30% عروض — التوازن يرفع الثقة والمبيعات.',
                      onOpenTips: () => Navigator.pushNamed(context, RouteNames.tips),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
      ),
    );
  }
}

/* ----------------------------- Widgets ----------------------------- */

class _Header extends StatelessWidget {
  final String username;
  final File? brandFile;
  final VoidCallback onBrandTap;

  const _Header({
    required this.username,
    required this.brandFile,
    required this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.18),
            Theme.of(context).colorScheme.secondary.withOpacity(0.12),
          ],
        ),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SmartMark',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'مرحبًا، $username 👋',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                const Text('خطة تسويق جاهزة في دقائق — بالعربي وببساطة.'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onBrandTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
                color: Theme.of(context).cardColor,
              ),
              child: brandFile == null
                  ? const Icon(Icons.photo, size: 28)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(brandFile!, fit: BoxFit.cover),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int plansCount;

  final String brandStatusTitle;
  final String brandStatusValue;
  final String brandStatusSubtitle;
  final IconData brandStatusIcon;

  const _StatsRow({
    required this.plansCount,
    required this.brandStatusTitle,
    required this.brandStatusValue,
    required this.brandStatusSubtitle,
    required this.brandStatusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'عدد الخطط',
            value: '$plansCount',
            icon: Icons.folder_open,
            subtitle: plansCount == 0 ? 'ابدأ أول خطة الآن' : 'خطط محفوظة محليًا',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: brandStatusTitle,
            value: brandStatusValue,
            subtitle: brandStatusSubtitle,
            icon: brandStatusIcon,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onPlans;
  final VoidCallback onBrand;
  final VoidCallback onTips;
  final VoidCallback onCalendar;

  const _QuickActionsGrid({
    required this.onCreate,
    required this.onPlans,
    required this.onBrand,
    required this.onTips,
    required this.onCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_ActionItem>[
      _ActionItem('إنشاء خطة', Icons.add_circle_outline, onCreate),
      _ActionItem('خططي', Icons.folder_outlined, onPlans),
      _ActionItem('هويةالمشروع', Icons.image_outlined, onBrand),
      _ActionItem('نصائح', Icons.lightbulb_outline, onTips),
     
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (context, i) => _QuickActionCard(item: items[i]),
    );
  }
}

class _ActionItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _ActionItem(this.title, this.icon, this.onTap);
}

class _QuickActionCard extends StatelessWidget {
  final _ActionItem item;
  const _QuickActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.7)),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.12),
                ),
                child: Icon(item.icon),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const Icon(Icons.chevron_left),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLastPlan extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyLastPlan({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.auto_awesome, size: 34),
            const SizedBox(height: 8),
            const Text('ابدأ أول خطة الآن ✨', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('ادخل معلومات بسيطة… وخذ خطة محتوى وإعلانات وتقويم نشر.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onCreate,
              child: const Text('إنشاء خطة جديدة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastPlanCard extends StatelessWidget {
  final String title;
  final String meta;
  final String createdAt;
  final String? imagePath;
  final VoidCallback onOpen;

  const _LastPlanCard({
    required this.title,
    required this.meta,
    required this.createdAt,
    required this.onOpen,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return Card(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                        ),
                      )
                    : const Icon(Icons.description_outlined, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(meta, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      createdAt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipBanner extends StatelessWidget {
  final String text;
  final VoidCallback onOpenTips;

  const _TipBanner({required this.text, required this.onOpenTips});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenTips,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.7)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_left),
          ],
        ),
      ),
    );
  }
}
