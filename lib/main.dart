import 'package:flutter/material.dart';
import 'package:news_app/Providers/Language_Provider.dart';
import 'package:news_app/Providers/Theme_Provider.dart';
import 'package:news_app/Providers/favorites_provider.dart';
import 'package:news_app/Screens/Home_Screen.dart';
import 'package:news_app/Screens/favorites/favorites_screen.dart';
import 'package:news_app/core/App_Routes.dart';
import 'package:news_app/core/App_Themes.dart';
import 'package:news_app/core/cache/cache_manager.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.homeRouteName,
      routes: {
        AppRoutes.homeRouteName: (context) => const HomeScreen(),
        AppRoutes.favoritesRouteName: (context) => const FavoritesScreen(),
      },
      theme: AppThemes.LightMode,
      darkTheme: AppThemes.DarkMode,
      themeMode: themeProvider.themeProvider,
    );
  }
}
