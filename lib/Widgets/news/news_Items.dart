import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Widgets/news/news_bottom_sheet.dart';
import 'package:news_app/api/model/news.dart';
import 'package:news_app/core/App_Size.dart';

class NewsItems extends StatelessWidget {
  final News news;
  const NewsItems({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    DateTime? parsedDate;
    if (news.publishedAt != null && news.publishedAt!.isNotEmpty) {
      parsedDate = DateTime.tryParse(news.publishedAt!);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => NewsBottomSheet(news: news),
        );
      },
      child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: width*0.02,
        vertical: height*0.015
      ),
      margin: EdgeInsets.symmetric(
        horizontal: width*0.04,
      ),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).splashColor,
          width: 2
        ),
      ),
      child: Column(
        spacing: height*0.02,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (news.urlToImage != null && news.urlToImage!.isNotEmpty)
                ? Image.network(
                    news.urlToImage!,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  )
                : Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
          ),
          Text(news.title ?? "" ,
          style: Theme.of(context).textTheme.bodyMedium,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("By : ${news.author}",
                  style: Theme.of(context).textTheme.titleMedium,),
              ),
              Text(
                parsedDate != null
                    ? DateFormat("dd/MM/yyyy").format(parsedDate)
                    : "",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )
        ],
      ),
    ),
    );
  }
}
