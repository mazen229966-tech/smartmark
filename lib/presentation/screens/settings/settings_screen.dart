import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/local/prefs/prefs_helper.dart';
import '../../../state/providers/app_settings_provider.dart';
import '../../../state/providers/brand_provider.dart';
import '../../../state/providers/plan_provider.dart';
import '../../../state/providers/tips_provider.dart';
import '../../routes/route_names.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<bool> _confirm(BuildContext context, String title, String body) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('تأكيد')),
        ],
      ),
    );
    return ok == true;
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final isDark = settings.themeMode == ThemeMode.dark;

    final planProvider = context.read<PlanProvider>();
    final brandProvider = context.read<BrandProvider>();
    final tipsProvider = context.read<TipsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: SwitchListTile(
              value: isDark,
              onChanged: (_) => context.read<AppSettingsProvider>().toggleTheme(),
              title: const Text('الوضع الليلي'),
              subtitle: const Text('تبديل الثيم بين فاتح/داكن'),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              title: const Text('هوية المشروع (الصور)'),
              subtitle: const Text('اختيار/حذف صورة الشعار أو المنتج'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.pushNamed(context, RouteNames.brandKit),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              title: const Text('مسح الخطط المحفوظة'),
              subtitle: const Text('يحذف جميع الخطط من قاعدة البيانات (Sqflite)'),
              trailing: const Icon(Icons.delete_outline),
              onTap: () async {
                final ok = await _confirm(
                  context,
                  'مسح جميع الخطط؟',
                  'سيتم حذف كل الخطط المحفوظة نهائيًا من قاعدة البيانات.',
                );
                if (!ok) return;

                await planProvider.clearAllPlansFromDb();
                if (!context.mounted) return;

                _snack(context, 'تم مسح جميع الخطط ✅');
              },
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('مسح بيانات المستخدم (SharedPreferences)'),
              subtitle: const Text('يمسح الاسم + Onboarding + المفضلة + صورة البراند'),
              trailing: const Icon(Icons.person_remove_outlined),
              onTap: () async {
                final ok = await _confirm(
                  context,
                  'مسح بيانات المستخدم؟',
                  'سيتم حذف بيانات المستخدم من الجهاز، وستحتاج لإعادة الإعداد عند فتح التطبيق.',
                );
                if (!ok) return;

                // مسح مفضلة + صورة + prefs
                await tipsProvider.clearFavorites();
                await brandProvider.clearBrandImage();
                await PrefsHelper.clearAll();

                if (!context.mounted) return;
                _snack(context, 'تم مسح بيانات المستخدم ✅');

                // يرجع للسلاش ليعيد تحديد المسار (onboarding/user setup)
                Navigator.pushNamedAndRemoveUntil(context, RouteNames.splash, (_) => false);
              },
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              title: const Text('إعادة ضبط التطبيق بالكامل'),
              subtitle: const Text('يمسح الخطط + بيانات المستخدم (Reset كامل)'),
              trailing: const Icon(Icons.restart_alt),
              onTap: () async {
                final ok = await _confirm(
                  context,
                  'إعادة ضبط بالكامل؟',
                  'سيتم حذف جميع البيانات (الخطط + المستخدم) وإعادة التطبيق كالجديد.',
                );
                if (!ok) return;

                await planProvider.clearAllPlansFromDb();
                await tipsProvider.clearFavorites();
                await brandProvider.clearBrandImage();
                await PrefsHelper.clearAll();

                if (!context.mounted) return;
                _snack(context, 'تمت إعادة الضبط ✅');

                Navigator.pushNamedAndRemoveUntil(context, RouteNames.splash, (_) => false);
              },
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: const ListTile(
              title: Text('عن التطبيق'),
              subtitle: Text('SmartMark — مولد خطط تسويقية ذكي وبسيط للمشاريع الصغيرة'),
            ),
          ),
        ],
      ),
    );
  }
}
