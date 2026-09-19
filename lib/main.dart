import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/Screens/Home_Screen.dart';
import 'package:news_app/Screens/favorites/favorites_screen.dart';
import 'package:news_app/Screens/news_details/article_web_view_screen.dart';
import 'package:news_app/core/App_Routes.dart';
import 'package:news_app/core/App_Themes.dart';
import 'package:news_app/core/cache/cache_manager.dart';
import 'package:news_app/cubits/favorites/favorites_cubit.dart';
import 'package:news_app/cubits/language/language_cubit.dart';
import 'package:news_app/cubits/theme/theme_cubit.dart';
import 'package:news_app/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => FavoritesCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, languageCode) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(languageCode),
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.homeRouteName,
              routes: {
                AppRoutes.homeRouteName: (context) => const HomeScreen(),
                AppRoutes.favoritesRouteName: (context) => const FavoritesScreen(),
                AppRoutes.articleWebViewRouteName: (context) => const ArticleWebViewScreen(),
              },
              theme: AppThemes.LightMode,
              darkTheme: AppThemes.DarkMode,
              themeMode: themeMode,
            );
          },
        );
      },
    );
  }
}
