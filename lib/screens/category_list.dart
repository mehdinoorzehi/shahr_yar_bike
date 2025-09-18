import 'package:bike/widgets/button.dart';
import 'package:flutter/material.dart';

class NearStationCards extends StatefulWidget {
  const NearStationCards({super.key});

  @override
  State<NearStationCards> createState() => _NearStationCardsState();
}

class _NearStationCardsState extends State<NearStationCards> {
  final PageController _pageController = PageController(viewportFraction: 0.78);
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPage = _pageController.initialPage.toDouble();
    _pageController.addListener(() {
      setState(() {
        _currentPage =
            _pageController.page ?? _pageController.initialPage.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = AppDatabase.categories;

    return SizedBox(
      height: 300, // ارتفاع اسلاید
      child: PageView.builder(
        controller: _pageController,
        reverse: true,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final distance = (_currentPage - index).abs();
          final double scale = (1 - (distance * 0.1))
              .clamp(0.9, 1.05)
              .toDouble();
          final double opacity = (1 - (distance * 0.35))
              .clamp(0.6, 1.0)
              .toDouble();

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: _StationCard(category: categories[index]),
            ),
          );
        },
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
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Image.asset(
                'assets/img/Bitmap.png',
                width: 200,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 44,
                width: 160,
                child: MyButton(buttonText: 'فاصله 50 متر', onTap: () {}),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ایستگاه ${category.title}',
              textDirection: TextDirection.rtl,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'تعداد دوچرخه: 2',
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha:  0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'جای پارک: 4',
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha:  0.7),
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
