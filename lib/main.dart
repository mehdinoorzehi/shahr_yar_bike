import 'package:bike/app_routes.dart';
import 'package:bike/conf/setup.dart';
import 'package:bike/langs/app_translations.dart';
import 'package:bike/langs/translation_service.dart';
import 'package:bike/theme/mange_theme.dart';
import 'package:bike/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import 'web_update_checker.dart'
    if (dart.library.io) 'stub.dart';

void main() async {
  await setUp();

  final translationService = await Get.putAsync(
    () => TranslationService().init(),
  );

  runApp(MyApp(translationService: translationService));

  // فقط در وب
  if (kIsWeb) {
    setupWebUpdateChecker();
  }
}

class MyApp extends StatelessWidget {
  final TranslationService translationService;

  const MyApp({super.key, required this.translationService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final themeType = themeProvider.themeType;

          return ToastificationWrapper(
            child: Sizer(
              builder: (context, orientation, deviceType) {
                return Obx(() {
                  // ✅ از Rx برای واکنش به تغییر زبان استفاده می‌کنیم
                  final locale = translationService.currentLocale.value;

                  final app = GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    translations: AppTranslations(),
                    locale: translationService.currentLocale.value,
                    key: ValueKey(locale.languageCode),
                    fallbackLocale: const Locale('fa'),
                    supportedLocales: const [
                      Locale('fa'),
                      Locale('en'),
                      Locale('ar'),
                    ],
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    theme: AppThemes.lightThemes[themeType],
                    themeMode: ThemeMode.light,
                    defaultTransition: Transition.fadeIn,
                    getPages: AppRoutes.pages,
                    initialRoute: AppRoutes.languageSelector,
                    routingCallback: (routing) {
                      if (routing != null && kDebugMode) {
                        if (kDebugMode) {
                          print("Navigated to ${routing.current}");
                        }
                      }
                    },
                  );

                  final screenWidth = MediaQuery.of(context).size.width;
                  const tabletBreakpoint = 600.0;

                  if (screenWidth > tabletBreakpoint) {
                    final borderRadius = BorderRadius.circular(30);
                    return Center(
                      child: Container(
                        width: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 16),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: app,
                        ),
                      ),
                    );
                  }

                  return app;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
