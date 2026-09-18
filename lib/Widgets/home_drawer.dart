import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/App_Colors.dart';
import 'package:news_app/core/App_Images.dart';
import 'package:news_app/core/App_Routes.dart';
import 'package:news_app/cubits/language/language_cubit.dart';
import 'package:news_app/cubits/theme/theme_cubit.dart';
import 'package:news_app/l10n/app_localizations.dart';

class HomeDrawer extends StatelessWidget {
  final VoidCallback onGoToHome;

  const HomeDrawer({super.key, required this.onGoToHome});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.BlackColor,
      child: Column(
        children: [
          // White header box with "News App"
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              l10n.news_App,
              style: const TextStyle(
                color: Color(0xFF171717),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Go To Home
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onGoToHome();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Image.asset(
                    AppImages.HomeIcon,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    l10n.go_To_Home,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            height: 28,
          ),

          // 2. Bookmarks / Favorites
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.favoritesRouteName);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.bookmark_outline_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    l10n.bookmarks,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            height: 28,
          ),

          // 2. Theme Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppImages.ThemeIcon,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      l10n.theme,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: DropdownButton<ThemeMode>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF171717),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 28,
                        ),
                        value: themeMode,
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(
                              l10n.dark,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(
                              l10n.light,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (newTheme) {
                          if (newTheme != null) {
                            context.read<ThemeCubit>().changeTheme(newTheme);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            height: 28,
          ),

          // 3. Language Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppImages.LanguageIcon,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      l10n.language,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BlocBuilder<LanguageCubit, String>(
                  builder: (context, languageCode) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF171717),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 28,
                        ),
                        value: languageCode,
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(
                              l10n.english,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'ar',
                            child: Text(
                              l10n.arabic,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (newLang) {
                          if (newLang != null) {
                            context.read<LanguageCubit>().changeLanguage(newLang);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
