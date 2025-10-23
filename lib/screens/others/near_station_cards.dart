import 'package:bike/widgets/button.dart';
import 'package:flutter/material.dart';

class NearStationCards extends StatelessWidget {
  const NearStationCards({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = AppDatabase.categories;
    final controller = PageController(viewportFraction: 0.78);

    return SizedBox(
      height: 300,
      child: PageView.custom(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          if (index >= categories.length) return null;
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double value = 0.0;
              if (controller.position.haveDimensions) {
                value = controller.page! - index;
              } else {
                value = controller.initialPage - index.toDouble();
              }

              // نرم کردن انیمیشن‌ها با منحنی easeOut
              final double scale = (1 - (value.abs() * 0.1))
                  .clamp(0.9, 1.05)
                  .toDouble();
              final double opacity = (1 - (value.abs() * 0.35))
                  .clamp(0.6, 1.0)
                  .toDouble();

              // اضافه کردن slight rotation برای جلوه‌ی depth
              final double rotation = value * 0.08; // زاویه جزئی

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015)
                  ..rotateY(rotation)
                  // ignore: deprecated_member_use
                  ..scale(scale),
                child: Opacity(
                  opacity: opacity,
                  child: RepaintBoundary(
                    child: _StationCard(category: categories[index]),
                  ),
                ),
              );
            },
          );
        }, childCount: categories.length),
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  final Category category;
  const _StationCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [theme.colorScheme.onPrimary, theme.colorScheme.secondary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تصویر
            Center(
              child: FadeInImage(
                placeholder: const AssetImage('assets/img/loading.gif'),
                image: const AssetImage('assets/img/Bitmap.png'),
                width: 200,
                height: 140,
                imageErrorBuilder: (_, __, ___) => const Icon(Icons.cloud),
              ),
            ),
            const SizedBox(height: 10),

            // دکمه فاصله
            Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 44,
                  width: 160,
                  child: MyButton(buttonText: 'فاصله ۵۰ متر', onTap: () {}),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // عنوان
            Text(
              'ایستگاه ${category.title}',
              textDirection: TextDirection.rtl,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 4),

            // اطلاعات
            Text(
              'تعداد دوچرخه: ۲',
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'جای پارک: ۴',
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDatabase {
  static List<Category> get categories {
    return [
      Category(id: 102, title: 'میدان آزادی'),
      Category(id: 103, title: 'خیابان امام'),
      Category(id: 105, title: 'پل خواجو'),
    ];
  }
}

class Category {
  final int id;
  final String title;

  Category({required this.id, required this.title});
}
