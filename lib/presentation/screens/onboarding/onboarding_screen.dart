import 'package:flutter/material.dart';
import '../../../data/local/prefs/prefs_helper.dart';
import '../../routes/route_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardPage> pages = const [
    _OnboardPage(
      icon: Icons.auto_awesome,
      title: 'خطة تسويق جاهزة في دقائق',
      body: 'أدخل معلومات بسيطة عن مشروعك، وخذ أفكار محتوى + إعلانات + جدول نشر.',
    ),
    _OnboardPage(
      icon: Icons.copy_all,
      title: 'انسخ وشارك بسهولة',
      body: 'انسخ الخطة كاملة بضغطة واحدة، أو انسخ كل قسم لوحده مع إشعارات لطيفة.',
    ),
    _OnboardPage(
      icon: Icons.image_outlined,
      title: 'اربط هويتك بالخطط',
      body: 'أضف صورة شعار/منتج، وسيتم حفظها تلقائيًا مع كل خطة داخل التطبيق.',
    ),
  ];

  Future<void> _finish() async {
    await PrefsHelper.setHasOnboarded(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.userSetup);
  }

  void _next() {
    if (_index < pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // Top bar: Skip
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: _finish,
                    child: const Text('تخطي'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => _OnboardingCard(page: pages[i]),
                ),
              ),

              const SizedBox(height: 12),

              // Dots + Next button
              Row(
                children: [
                  _Dots(count: pages.length, index: _index),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(isLast ? 'ابدأ الآن' : 'التالي'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* --------------------------- UI Pieces --------------------------- */

class _OnboardPage {
  final IconData icon;
  final String title;
  final String body;

  const _OnboardPage({
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardPage page;
  const _OnboardingCard({required this.page});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.16),
              Theme.of(context).colorScheme.secondary.withOpacity(0.10),
            ],
          ),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.6)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              ),
              child: Icon(page.icon, size: 42),
            ),
            const SizedBox(height: 18),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              page.body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(left: 6),
          width: active ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor.withOpacity(0.6),
          ),
        );
      }),
    );
  }
}
