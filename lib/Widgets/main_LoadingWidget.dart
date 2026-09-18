import 'package:flutter/material.dart';
import 'package:news_app/Widgets/shimmer/news_item_shimmer.dart';

class MainLoadingwidget extends StatelessWidget {
  const MainLoadingwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: NewsListShimmer(itemCount: 4),
    );
  }
}
