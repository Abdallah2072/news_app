import 'package:flutter/material.dart';
import 'package:news_app/Widgets/news/news_Widget.dart';
import 'package:news_app/Widgets/sources/sources_tab.dart';
import 'package:news_app/api/model/Source.dart';
import 'package:news_app/core/App_Colors.dart';
import 'package:news_app/core/App_Size.dart';

// ignore: must_be_immutable
class SourcesWidget extends StatefulWidget {
  List<Sources> sourceList;

  SourcesWidget({super.key, required this.sourceList});

  @override
  State<SourcesWidget> createState() => _SourcesWidgetState();
}

class _SourcesWidgetState extends State<SourcesWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (selectedIndex >= widget.sourceList.length) {
      selectedIndex = 0;
    }
    var height = context.height;
    // var width = context.width;
    return DefaultTabController(
      length: widget.sourceList.length,
      child: Column(
        spacing: height * 0.015,
        children: [
          TabBar(
            dividerColor: AppColors.TransparenetColor,
            indicatorColor: Theme.of(context).splashColor,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },
            tabs: widget.sourceList.map((Sources) {
              return SourcesTab(
                Source: Sources,
                isSelected: selectedIndex == widget.sourceList.indexOf(Sources),
              );
            }).toList(),
          ),
          Expanded(child: NewsWidget(source: widget.sourceList[selectedIndex])),
        ],
      ),
    );
  }
}
