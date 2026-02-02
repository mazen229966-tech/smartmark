import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/plan_input.dart';
import '../../../state/providers/plan_provider.dart';
import '../../routes/route_names.dart';

class CreatePlanWizardScreen extends StatefulWidget {
  const CreatePlanWizardScreen({super.key});

  @override
  State<CreatePlanWizardScreen> createState() => _CreatePlanWizardScreenState();
}

class _CreatePlanWizardScreenState extends State<CreatePlanWizardScreen> {
  int _step = 0;

  final _formKey = GlobalKey<FormState>();

  final _businessName = TextEditingController();
  final _audience = TextEditingController();

  String _category = 'مطعم';
  String _goal = 'زيادة مبيعات';
  String _platform = 'Instagram';
  String _budget = 'Low';

  final List<String> categories = const ['مطعم', 'ملابس', 'عطور', 'خدمات', 'متجر إلكتروني'];
  final List<String> goals = const ['زيادة مبيعات', 'زيادة متابعين', 'إطلاق منتج', 'زيادة الوعي'];
  final List<String> platforms = const ['Instagram', 'TikTok', 'Snapchat', 'Facebook', 'X'];
  final List<String> budgets = const ['Low', 'Medium', 'High'];

  @override
  void dispose() {
    _businessName.dispose();
    _audience.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    // نتحقق فقط من الحقول الموجودة بالخطوة الحالية
    // أسهل حل: نستخدم فورم واحد لكن نمنع الانتقال إذا كانت حقول الخطوات السابقة غير صحيحة
    // هنا: نتحقق على مستوى الفورم عند النهاية، وعند التنقل نتحقق حسب الحاجة
    if (_step == 0) {
      return (_businessName.text.trim().length >= 2);
    }
    if (_step == 2) {
      return (_audience.text.trim().length >= 4);
    }
    return true;
  }

  void _next() {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تأكد من تعبئة البيانات بشكل صحيح')),
      );
      return;
    }
    if (_step < 3) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _generate() {
    // تحقق نهائي
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أكمل البيانات المطلوبة')),
      );
      return;
    }

    final input = PlanInput(
      businessName: _businessName.text.trim(),
      category: _category,
      goal: _goal,
      platform: _platform,
      audience: _audience.text.trim(),
      budgetLevel: _budget,
    );

    context.read<PlanProvider>().setCurrentInput(input);

    Navigator.pushNamed(context, RouteNames.processing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء خطة تسويق'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _step,
          onStepContinue: _step == 3 ? _generate : _next,
          onStepCancel: _back,
          controlsBuilder: (context, details) {
            final isLast = _step == 3;
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLast ? 'توليد الخطة' : 'التالي'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _step == 0 ? null : details.onStepCancel,
                    child: const Text('رجوع'),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('معلومات المشروع'),
              isActive: _step >= 0,
              state: _step > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _businessName,
                    decoration: const InputDecoration(
                      labelText: 'اسم المشروع/المنتج',
                      hintText: 'مثال: مطعم الذواقة',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().length < 2) return 'الاسم مطلوب';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                    decoration: const InputDecoration(labelText: 'المجال'),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('الهدف التسويقي'),
              isActive: _step >= 1,
              state: _step > 1 ? StepState.complete : StepState.indexed,
              content: DropdownButtonFormField<String>(
                value: _goal,
                items: goals
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _goal = v!),
                decoration: const InputDecoration(labelText: 'هدف الحملة'),
              ),
            ),
            Step(
              title: const Text('الجمهور والمنصة'),
              isActive: _step >= 2,
              state: _step > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _platform,
                    items: platforms
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) => setState(() => _platform = v!),
                    decoration: const InputDecoration(labelText: 'المنصة الأساسية'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _audience,
                    decoration: const InputDecoration(
                      labelText: 'وصف الجمهور المستهدف',
                      hintText: 'مثال: شباب 18-25 في صنعاء مهتمين بالأكل السريع',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().length < 4) return 'اكتب وصف مختصر للجمهور';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('الميزانية'),
              isActive: _step >= 3,
              state: _step == 3 ? StepState.editing : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _budget,
                    items: budgets
                        .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
                    onChanged: (v) => setState(() => _budget = v!),
                    decoration: const InputDecoration(labelText: 'مستوى الميزانية'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Low: محتوى عضوي + إعلان بسيط\nMedium: إعلان أسبوعي + تعاون\nHigh: حملات + مؤثرين',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
