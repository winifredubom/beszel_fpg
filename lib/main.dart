import 'package:beszel_fpg/features/authentication/presentation/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/app_config.dart';
import 'core/language/language_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'core/navigation/app_router.dart';
import 'core/storage/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await StorageService.init();
  await ThemeManager.instance.init();
  await LanguageManager.instance.initialize();
  
  runApp(ProviderScope(child: const BeszelApp()));
}

class BeszelApp extends StatelessWidget {
  const BeszelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: LanguageManager.instance,
          builder: (context, _) {
            return CupertinoApp.router(
              title: AppConfig.appName,
              theme: ThemeManager.instance.isDarkMode 
                  ? AppTheme.darkCupertinoTheme 
                  : AppTheme.lightCupertinoTheme,
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              locale: LanguageManager.instance.currentLocale,
              supportedLocales: LanguageManager.supportedLocales.keys.map((locale) {
                final parts = locale.split('_');
                return Locale(parts[0], parts[1]);
              }).toList(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          }
        );
      },
    );
  }
}
