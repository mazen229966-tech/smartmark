import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_keys.dart';

class GeminiApiService {
  static const String _model = 'gemini-2.5-flash';

  static Future<String> improveFullPlan({
    required String businessName,
    required String category,
    required String goal,
    required String platform,
    required String audience,
    required String budgetLevel,
  }) async {
    final prompt = '''
أنت خبير تسويق ومحتوى عربي. أنشئ خطة تسويق قوية ومبسطة لمشروع صغير، تكون عملية وسهلة التنفيذ.

بيانات المشروع:
- اسم المشروع: $businessName
- المجال: $category
- الهدف: $goal
- المنصة الأساسية: $platform
- الجمهور المستهدف: $audience
- مستوى الميزانية: $budgetLevel (Low/Medium/High)

قواعد مهمة:
1) اكتب بالعربية الفصحى المبسطة.
2) اجعل الخطة قابلة للتطبيق فورًا، بدون كلام عام.
3) اجعل كل نقطة قصيرة وواضحة.
4) أعد النتائج بصيغة JSON فقط وبدون أي شرح خارج JSON.
5) التزم تمامًا بالمفاتيح التالية (لا تغيّرها):

{
  "headline": "عنوان جذاب للخطة في سطر واحد",
  "contentIdeas": ["6 أفكار محتوى قوية"],
  "adCopies": ["3 نصوص إعلانية قصيرة مع CTA واضح"],
  "hashtags": ["10 هاشتاقات مناسبة"],
  "weeklyCalendar": {
    "السبت": "ماذا ننشر؟",
    "الأحد": "...",
    "الاثنين": "...",
    "الثلاثاء": "...",
    "الأربعاء": "...",
    "الخميس": "...",
    "الجمعة": "..."
  },
  "budgetPlan": "توزيع الميزانية بشكل بسيط وواضح حسب مستوى الميزانية",
  "kpis": ["5 مؤشرات قياس أداء KPI مناسبة للهدف"]
}

ملاحظة: اجعل المحتوى مناسبًا لمنصة $platform تحديدًا.
''';

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/$_model:generateContent?key=${ApiKeys.geminiApiKey}',
    );

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Gemini HTTP ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (text == null) {
      throw Exception('Gemini response missing text: ${res.body}');
    }

    return text.toString();
  }
}
