import 'package:flutter/material.dart';
import 'package:news_app/Widgets/main_Error_Widget.dart';
import 'package:news_app/Widgets/main_LoadingWidget.dart';
import 'package:news_app/Widgets/sources/sources_Widget.dart';
import 'package:news_app/api/api_Manager.dart';
import 'package:news_app/api/model/Source_Response.dart';
import 'package:news_app/api/model/category_model.dart';

class CategoryDetails extends StatefulWidget {
  final CategoryModel category;
  const CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SourceResponse>(
      future: ApiManager.getSources(widget.category.id),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MainLoadingwidget();
        } else if (snapshot.hasError) {
          return MainErrorWidget(
            errorMessage: snapshot.error?.toString() ?? "Something went wrong",
            onPressed: () {
              setState(() {});
            },
          );
        }
        // Error from API
        else if (snapshot.data?.status != "ok") {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                snapshot.data?.message ?? "Error loading sources",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  "Try Again",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          );
        } else {
          var sourcesList = snapshot.data?.sources ?? [];
          // Success Response
          return sourcesList.isEmpty
              ? Center(
                  child: Text(
                    "No Sources Item Founded",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )
              : SourcesWidget(sourceList: sourcesList);
        }
      },
    );
  }
}
