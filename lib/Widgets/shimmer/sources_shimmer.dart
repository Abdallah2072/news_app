import 'package:flutter/material.dart';
import 'package:news_app/Widgets/shimmer/news_item_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class SourcesShimmer extends StatelessWidget {
  const SourcesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF242730) : const Color(0xFFE2E4E9);
    final highlightColor = isDark ? const Color(0xFF363B48) : const Color(0xFFF3F4F6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Sources Tabs Placeholder
        SizedBox(
          height: 46,
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final widths = [80.0, 110.0, 90.0, 120.0, 85.0];
                return Container(
                  width: widths[index % widths.length],
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // News List Shimmer underneath
        const Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: NewsListShimmer(itemCount: 3),
          ),
        ),
      ],
    );
  }
}
