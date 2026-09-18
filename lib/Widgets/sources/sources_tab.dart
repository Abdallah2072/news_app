import 'package:flutter/material.dart';
import 'package:news_app/api/model/Source.dart';

class SourcesTab extends StatelessWidget {
  final Sources Source ;
  final isSelected ;
  const SourcesTab({super.key , required this.Source , required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Text(Source.name ?? "" ,
    style: isSelected ? Theme.of(context).textTheme.bodyLarge
        : Theme.of(context).textTheme.titleLarge);
  }
}
