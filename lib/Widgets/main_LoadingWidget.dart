import 'package:flutter/material.dart';
import 'package:news_app/core/App_Colors.dart';

class MainLoadingwidget extends StatelessWidget {
  const MainLoadingwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.GrayColor,
      ),
    );
  }
}
