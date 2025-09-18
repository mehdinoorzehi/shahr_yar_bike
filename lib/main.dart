import 'package:bike/app_routes.dart';
import 'package:bike/conf/setup.dart';

import 'package:bike/theme/mange_theme.dart';
import 'package:bike/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

class _CupertinoScrollBehavior extends MaterialScrollBehavior {
  const _CupertinoScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}

void main() async {
  await setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                final app = Directionality(
                  textDirection: TextDirection.rtl,
                  child: ScrollConfiguration(
                    behavior: const _CupertinoScrollBehavior(),
                    child: GetMaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: AppThemes.lightThemes[themeType],
                      // darkTheme: AppThemes.darkThemes[themeType],
                      themeMode: ThemeMode.light,

                      defaultTransition: Transition.fadeIn,
                      getPages: AppRoutes.pages,
                      initialRoute: AppRoutes.splash,
                      routingCallback: (routing) {
                        // optional:
                        if (routing != null) {
                          if (kDebugMode) {
                            print("Navigated to ${routing.current}");
                          }
                        }
                      },
                    ),
                  ),
                );

                if (kIsWeb) {
                  final borderRadius = BorderRadius.circular(30);
                  return Center(
                    child: Container(
                      width: 500,
                      // height: 700,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 40,
                            spreadRadius: 0,
                            offset: const Offset(0, 16),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(borderRadius: borderRadius, child: app),
                    ),
                  );
                }

                return app;
              },
            ),
          );
        },
      ),
    );
  }
}
