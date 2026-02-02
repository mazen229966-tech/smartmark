import 'package:flutter/material.dart';
import '../../data/local/prefs/prefs_helper.dart';
import '../../data/models/marketing_tip.dart';

class TipsProvider extends ChangeNotifier {
  String _selectedCategory = 'مطعم';
  String get selectedCategory => _selectedCategory;

  String _query = '';
  String get query => _query;

  Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  final List<MarketingTip> _all = _seedTips();

  Future<void> init() async {
    final fav = await PrefsHelper.getFavoriteTips();
    _favorites = fav.toSet();
    notifyListeners();
  }

  void setCategory(String v) {
    _selectedCategory = v;
    notifyListeners();
  }

  void setQuery(String v) {
    _query = v;
    notifyListeners();
  }

  List<MarketingTip> get filtered {
    final base = _all.where((t) => t.category == _selectedCategory).toList();

    if (_query.trim().isEmpty) return base;

    final q = _query.trim();
    return base.where((t) {
      return t.title.contains(q) || t.body.contains(q);
    }).toList();
  }

  List<MarketingTip> get favoriteList {
    return _all.where((t) => _favorites.contains(t.id)).toList();
  }

  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    await PrefsHelper.setFavoriteTips(_favorites.toList());
    notifyListeners();
  }

  static List<MarketingTip> _seedTips() {
    return const [
      // مطعم
      MarketingTip(
        id: 'res_1',
        category: 'مطعم',
        title: 'قاعدة “طبق واحد بطل”',
        body: 'اختر طبقًا واحدًا مميزًا وركز عليه 3 مرات أسبوعيًا (فيديو + صورة + قصة) لزيادة الطلب.',
      ),
      MarketingTip(
        id: 'res_2',
        category: 'مطعم',
        title: 'تصوير بسيط لكن فعال',
        body: 'استخدم إضاءة طبيعية قرب نافذة + خلفية نظيفة، ولقطة قريبة للطبق تزيد الشهية.',
      ),
      MarketingTip(
        id: 'res_3',
        category: 'مطعم',
        title: 'عروض “وقت محدود”',
        body: 'قدّم عرضًا لمدة 24 ساعة مرة بالأسبوع مع CTA واضح: “اطلب الآن”.',
      ),

      // ملابس
      MarketingTip(
        id: 'clo_1',
        category: 'ملابس',
        title: '3 تنسيقات لنفس القطعة',
        body: 'اعرض نفس القطعة بثلاث إطلالات مختلفة (عمل/خروج/يومي) لرفع قيمة المنتج.',
      ),
      MarketingTip(
        id: 'clo_2',
        category: 'ملابس',
        title: 'مقاسات واضحة = مبيعات أعلى',
        body: 'انشر دليل مقاسات مبسط + نصائح اختيار المقاس لتقليل الاسترجاع وزيادة الثقة.',
      ),
      MarketingTip(
        id: 'clo_3',
        category: 'ملابس',
        title: 'محتوى العملاء',
        body: 'اطلب من العملاء تصوير إطلالة (UGC) وقدّم لهم كود خصم بسيط مقابل النشر.',
      ),

      // عطور
      MarketingTip(
        id: 'per_1',
        category: 'عطور',
        title: 'قصة الرائحة',
        body: 'قسّم الرائحة لافتتاحية/قلب/قاعدة واصفها بكلمات بسيطة (حلو/خشبي/منعش).',
      ),
      MarketingTip(
        id: 'per_2',
        category: 'عطور',
        title: 'مناسبات = قرار أسرع',
        body: 'اعرض العطر حسب المناسبة: (دوام/مناسبات/يومي) لتسهيل قرار الشراء.',
      ),
      MarketingTip(
        id: 'per_3',
        category: 'عطور',
        title: 'عينات صغيرة',
        body: 'إذا ممكن: قدّم عينات صغيرة أو باقات، لأنها تقلل تردد الشراء.',
      ),

      // خدمات
      MarketingTip(
        id: 'srv_1',
        category: 'خدمات',
        title: 'قبل/بعد',
        body: 'اعرض نتيجة الخدمة “قبل/بعد” مع شرح قصير—هذا أفضل دليل اجتماعي.',
      ),
      MarketingTip(
        id: 'srv_2',
        category: 'خدمات',
        title: '3 أسئلة شائعة',
        body: 'انشر أسبوعيًا منشور “أسئلة شائعة” عن خدمتك، يقلل الرسائل ويزيد الثقة.',
      ),
      MarketingTip(
        id: 'srv_3',
        category: 'خدمات',
        title: 'عرض باقة',
        body: 'بدل خدمة واحدة، قدّم باقات (Basic/Pro/Premium) لتسهيل الاختيار.',
      ),

      // متجر إلكتروني
      MarketingTip(
        id: 'ecom_1',
        category: 'متجر إلكتروني',
        title: 'Unboxing سريع',
        body: 'فيديو فتح المنتج (10-20 ثانية) مع لقطة المنتج النهائية = معدل تحويل أعلى.',
      ),
      MarketingTip(
        id: 'ecom_2',
        category: 'متجر إلكتروني',
        title: 'أفضل 3 منتجات',
        body: 'انشر “أفضل 3 منتجات هذا الأسبوع” وكررها أسبوعيًا لبناء عادة شراء.',
      ),
      MarketingTip(
        id: 'ecom_3',
        category: 'متجر إلكتروني',
        title: 'سياسة توصيل واضحة',
        body: 'وضّح التوصيل/الاستبدال في بوست ثابت أو هايلايت لتقليل التردد.',
      ),
    ];
  }

  Future<void> clearFavorites() async {
  _favorites = {};
  await PrefsHelper.setFavoriteTips([]);
  notifyListeners();
}

}
