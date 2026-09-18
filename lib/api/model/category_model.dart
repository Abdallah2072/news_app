import 'package:flutter/material.dart';
import 'package:news_app/core/App_Images.dart';
import 'package:news_app/l10n/app_localizations.dart';

class CategoryModel {
  final String id;
  final String title;
  final String image;

  CategoryModel({
    required this.id,
    required this.title,
    required this.image,
  });

  static List<CategoryModel> getCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      CategoryModel(
        id: "general",
        title: l10n.general,
        image: AppImages.GeneralImg,
      ),
      CategoryModel(
        id: "business",
        title: l10n.business,
        image: AppImages.BusinessImg,
      ),
      CategoryModel(
        id: "sports",
        title: l10n.sports,
        image: AppImages.SportsImg,
      ),
      CategoryModel(
        id: "technology",
        title: l10n.technology,
        image: AppImages.TechnologyImg,
      ),
      CategoryModel(
        id: "entertainment",
        title: l10n.entertainment,
        image: AppImages.EntertainmentImg,
      ),
      CategoryModel(
        id: "health",
        title: l10n.health,
        image: AppImages.HealthImg,
      ),
      CategoryModel(
        id: "science",
        title: l10n.science,
        image: AppImages.ScienceImg,
      ),
    ];
  }
}
