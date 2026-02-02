
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/providers/brand_provider.dart';

class BrandKitScreen extends StatelessWidget {
  const BrandKitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.watch<BrandProvider>();
    final file = brand.brandImageFile;

    return Scaffold(
      appBar: AppBar(title: const Text('هوية المشروع (Brand Kit)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('صورة الشعار/المنتج', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Center(
                        child: brand.loading
                            ? const CircularProgressIndicator()
                            : (file != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(file, fit: BoxFit.cover, width: double.infinity),
                                  )
                                : const Text('لا توجد صورة بعد')),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: brand.loading ? null : () => context.read<BrandProvider>().pickBrandImage(),
                            icon: const Icon(Icons.image),
                            label: const Text('اختيار صورة'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: (file == null || brand.loading) ? null : () => context.read<BrandProvider>().clearBrandImage(),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('حذف'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (brand.brandImagePath != null)
                      Text(
                        'المسار: ${brand.brandImagePath}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '⭐ يتم استخدام هذه الصورة تلقائيًا مع أي خطة جديدة تحفظها.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
