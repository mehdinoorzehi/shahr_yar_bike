import 'package:bike/app_routes.dart';
import 'package:bike/langs/translation_service.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSelectorScreen extends StatefulWidget {
  const LanguageSelectorScreen({super.key});

  @override
  State<LanguageSelectorScreen> createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen> {
  String selectedLang = "فا";

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
          child: MyButton(
            isFocus: true,
            buttonText: 'get_started'.tr,
            onTap: () => Get.toNamed(AppRoutes.checkScreen),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            /// ✅ لوگوها وسط وسط صفحه
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset("assets/img/logo2.png", width: 120),
                  ),
                  const SizedBox(height: 20),
                  Image.asset("assets/img/logo3.png", width: 200),
                ],
              ),
            ),

            /// ✅ زبان + دکمه پایین صفحه
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LanguageSelectorWidget(
                    onSelect: (lang) => setState(() => selectedLang = lang),
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

class LanguageSelectorWidget extends StatefulWidget {
  final Function(String) onSelect;

  const LanguageSelectorWidget({super.key, required this.onSelect});

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  // پیش‌فرض روی فارسی
  String _selectedLang = "فا";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final currentLocale =
        Get.find<TranslationService>().currentLocale.value.languageCode;

    if (currentLocale == 'fa') {
      _selectedLang = 'فا';
    } else if (currentLocale == 'ar') {
      _selectedLang = 'ع';
    } else {
      _selectedLang = 'en';
    }
  }

  String _apiCodeFromUi(String uiCode) {
    if (uiCode == 'فا') return 'fa';
    if (uiCode == 'en') return 'en';
    if (uiCode == 'ع') return 'ar';
    return 'en';
  }

  void _selectLang(String code) async {
    setState(() {
      _selectedLang = code;
      _isLoading = true;
    });

    final apiCode = _apiCodeFromUi(code);

    final success = await Get.find<TranslationService>()
        .changeLanguageByApiCode(apiCode);

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      showErrorToast(
        description:
            'ارتباط با سرور برقرار نشد و ترجمه جدید دانلود نشد. در صورت وجود از ترجمهٔ محلی استفاده شد',
      );
    }

    widget.onSelect(code);
  }

  Widget _buildLangItem({
    required String code,
    required String label,
    required List<Color> gradientColors,
  }) {
    final bool isActive = _selectedLang == code;

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectLang(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isActive
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // آیکون زبان
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  code.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // متن زیر آیکون
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? Colors.white : Colors.white70,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 250,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        color: Colors.white.withValues(alpha: 0.1),
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLangItem(
                  code: "en",
                  label: "English",
                  gradientColors: [
                    const Color(0xFF74b9ff),
                    const Color(0xFF0984e3),
                  ],
                ),
                _buildLangItem(
                  code: "ع",
                  label: "العربية",
                  gradientColors: [
                    const Color(0xFF00b894),
                    const Color(0xFF00a085),
                  ],
                ),
                _buildLangItem(
                  code: "فا", // فارسی با کد درست
                  label: "فارسی",
                  gradientColors: [
                    const Color(0xFFFF6B6B),
                    const Color(0xFFEE5A24),
                  ],
                ),
              ],
            ),
    );
  }
}
