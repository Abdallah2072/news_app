import 'package:flutter/material.dart';
import 'package:news_app/core/App_Size.dart';
import 'package:shimmer/shimmer.dart';

class NewsItemShimmer extends StatelessWidget {
  const NewsItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF242730) : const Color(0xFFE2E4E9);
    final highlightColor = isDark ? const Color(0xFF363B48) : const Color(0xFFF3F4F6);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.015,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).splashColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: height * 0.02),

            // Title Line 1
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),

            // Title Line 2 (shorter)
            Container(
              height: 16,
              width: width * 0.55,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: height * 0.02),

            // Bottom Row: Author & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 12,
                  width: width * 0.28,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 12,
                  width: width * 0.20,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewsListShimmer extends StatelessWidget {
  final int itemCount;
  const NewsListShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => const NewsItemShimmer(),
    );
  }
}
