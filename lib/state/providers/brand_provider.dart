import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/local/prefs/prefs_helper.dart';

class BrandProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  String? _brandImagePath;
  String? get brandImagePath => _brandImagePath;

  File? get brandImageFile {
    final p = _brandImagePath;
    if (p == null) return null;
    final f = File(p);
    return f.existsSync() ? f : null;
  }

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadBrand() async {
    _brandImagePath = await PrefsHelper.getBrandImagePath();
    notifyListeners();
  }

  Future<void> pickBrandImage() async {
    _loading = true;
    notifyListeners();

    try {
      final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (x == null) return;

      _brandImagePath = x.path;
      await PrefsHelper.setBrandImagePath(_brandImagePath);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> clearBrandImage() async {
    _brandImagePath = null;
    await PrefsHelper.setBrandImagePath(null);
    notifyListeners();
  }
}
