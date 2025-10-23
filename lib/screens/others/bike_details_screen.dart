import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class BikeDetailsScreen extends StatefulWidget {
  const BikeDetailsScreen({super.key});

  @override
  State<BikeDetailsScreen> createState() => _BikeDetailsScreenState();
}

class _BikeDetailsScreenState extends State<BikeDetailsScreen> {
  final TextEditingController _issueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
              extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 30,
        surfaceTintColor: theme.colorScheme.primary,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: ListView(
        children: [
          // ---- Hero Header ----
          _Header(theme: theme),
      
          const SizedBox(height: 20),
      
          // ---- Info Cards ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    theme: theme,
                    icon: LucideIcons.badge,
                    title: "پلاک",
                    value: "103",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    theme: theme,
                    icon: LucideIcons.lock,
                    title: "قفل",
                    value: "A-45",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _InfoCard(
              theme: theme,
              icon: LucideIcons.map,
              title: "ایستگاه",
              value: "میدان آزادی",
              fullWidth: true,
            ),
          ),
      
          const SizedBox(height: 20),
      
          // ---- Instruction ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              shadowColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "لطفا پلاک 103 را در جایگاه 1 بررسی نمایید و فرمان باز شدن قفل را صادر نمایید تا دوچرخه آزاد شود",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      
          const SizedBox(height: 20),
      
          // ---- Unlock Button ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(LucideIcons.lock_open),
                label: const Text(
                  "قفل باز شود",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: () {
                },
              ),
            ),
          ),
      
          const SizedBox(height: 30),
      
          // ---- Report Section ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shadowColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "گزارش خرابی",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          LucideIcons.triangle_alert,
                          color: theme.colorScheme.error,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
      
                    // TextField جدا شده با RepaintBoundary
                    RepaintBoundary(
                      child: TextField(
                        textDirection: TextDirection.rtl,
                        controller: _issueController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "توضیحات خود را وارد کنید",
                          hintTextDirection: TextDirection.rtl,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton.icon(
                        icon: const Icon(LucideIcons.send),
                        label: const Text("ثبت خرابی"),
                        onPressed: () {
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
          const SizedBox(height: 20),
      
          // ---- Cancel Button ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
      
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(LucideIcons.circle_x, color: Colors.white),
                label: const Text(
                  "لغو سفر",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                },
              ),
            ),
          ),
      
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ---------------- Reusable Widgets ----------------

class _Header extends StatelessWidget {
  final ThemeData theme;
  const _Header({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.bike, size: 80, color: theme.colorScheme.onPrimary),
          const SizedBox(height: 10),
          Text(
            "جزئیات دوچرخه",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "شما 120 ثانیه فرصت دارید",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha:0.9),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String value;
  final bool fullWidth;

  const _InfoCard({
    required this.theme,
    required this.icon,
    required this.title,
    required this.value,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(alpha:  0.1),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
