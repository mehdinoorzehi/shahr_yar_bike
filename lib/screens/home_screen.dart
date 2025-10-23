import 'package:bike/screens/others/near_station_cards.dart';
import 'package:bike/widgets/animated_touch.dart';
import 'package:bike/widgets/drawer_avatar.dart';
import 'package:bike/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          // 🔹 فقط یک‌بار گرادینت برای کل پس‌زمینه رندر میشه
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🔹 محتوای اسکرول‌پذیر
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(theme: theme),
                const SizedBox(height: 25),
                _WeatherCard(theme: theme),
                const SizedBox(height: 25),
                _MiniCardRow(theme: theme),
                const SizedBox(height: 25),
                _TripCard(theme: theme),
                const SizedBox(height: 30),
                _SuggestionsHeader(theme: theme),
                const SizedBox(height: 10),
                const NearStationCards(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== 🔹 HEADER =====================
class _Header extends StatelessWidget {
  final ThemeData theme;
  const _Header({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return AnimatedTouch(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Icon(
                  LucideIcons.menu,
                  color: theme.colorScheme.onPrimary,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            'سلام مهدی 👋',
            style: theme.textTheme.titleLarge!.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const DrawerAvatar(),
        ],
      ),
    );
  }
}

// ===================== 🔹 WEATHER CARD =====================
class _WeatherCard extends StatelessWidget {
  final ThemeData theme;
  const _WeatherCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '12°',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'اصفهان',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                Text(
                  'چهارشنبه، 17 دی',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            FadeInImage(
              placeholder: const AssetImage('assets/img/loading.gif'),
              image: const AssetImage('assets/img/cloudly.png'),
              width: 80,
              height: 65,
              imageErrorBuilder: (_, __, ___) => const Icon(Icons.cloud),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== 🔹 MINI CARDS =====================
class _MiniCardRow extends StatelessWidget {
  final ThemeData theme;
  const _MiniCardRow({required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: const [
          _MiniCard(icon: LucideIcons.bike, title: "دوچرخه"),
          _MiniCard(icon: LucideIcons.smile, title: "اسکوتر"),
          _MiniCard(icon: LucideIcons.bike, title: "دوچرخه برقی"),
          _MiniCard(icon: LucideIcons.circle_parking, title: "پارکینگ"),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  const _MiniCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.onPrimary, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== 🔹 TRIP CARD =====================
class _TripCard extends StatelessWidget {
  final ThemeData theme;
  const _TripCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.7),
              theme.colorScheme.secondary.withValues(alpha: 0.9),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.bike,
                  color: theme.colorScheme.onPrimary,
                  size: 35,
                ),
                const SizedBox(width: 12),
                Text(
                  "سفر جاری",
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tripInfo(theme, LucideIcons.clock, "مدت زمان", "32 دقیقه"),
                _tripInfo(theme, LucideIcons.wallet, "هزینه", "45,000 تومان"),
                _tripInfo(theme, LucideIcons.bike, "شماره پلاک", "22"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.onPrimary,
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              icon: const Icon(LucideIcons.check),
              label: const Text("پایان سفر"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripInfo(ThemeData theme, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.onPrimary, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          textDirection: TextDirection.rtl,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// ===================== 🔹 SUGGESTIONS HEADER =====================
class _SuggestionsHeader extends StatelessWidget {
  final ThemeData theme;
  const _SuggestionsHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'پیشنهادات',
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
