import 'package:flutter/material.dart';
import 'package:news_app/Widgets/main_Error_Widget.dart';
import 'package:news_app/Widgets/main_LoadingWidget.dart';
import 'package:news_app/Widgets/news/news_Items.dart';
import 'package:news_app/api/api_Manager.dart';
import 'package:news_app/api/model/Source.dart';
import 'package:news_app/api/model/news.dart';
import 'package:news_app/core/App_Size.dart';

class NewsWidget extends StatefulWidget {
  final Sources source;
  const NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final ScrollController _scrollController = ScrollController();
  List<News> _newsList = [];
  int _page = 1;
  int _totalResults = 0;
  static const int _pageSize = 10;
  bool _isLoading = false;
  String? _errorMessage;

  int get totalPages {
    if (_totalResults <= 0) return 1;
    // NewsAPI free tier limits to the first 100 results (max 10 pages)
    final effectiveTotal = _totalResults > 100 ? 100 : _totalResults;
    return (effectiveTotal / _pageSize).ceil().clamp(1, 10);
  }

  @override
  void initState() {
    super.initState();
    _goToPage(1);
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.id != widget.source.id) {
      _goToPage(1);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int newPage) async {
    setState(() {
      _page = newPage;
      _isLoading = true;
      _errorMessage = null;
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    try {
      final response = await ApiManager.getNewsBySourceId(
        widget.source.id ?? "",
        page: _page,
        pageSize: _pageSize,
      );

      if (response.status == "ok") {
        _newsList = response.articles ?? [];
        _totalResults = response.totalResults ?? _newsList.length;
      } else {
        _errorMessage = response.message ?? "Error loading news";
      }
    } catch (e) {
      _errorMessage = "Something went wrong";
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<int> _generatePageNumbers() {
    final maxPages = totalPages;
    if (maxPages <= 5) {
      return List.generate(maxPages, (i) => i + 1);
    }
    int start = _page - 2;
    int end = _page + 2;

    if (start < 1) {
      end += (1 - start);
      start = 1;
    }
    if (end > maxPages) {
      start -= (end - maxPages);
      end = maxPages;
    }
    start = start.clamp(1, maxPages);
    end = end.clamp(1, maxPages);

    return [for (int i = start; i <= end; i++) i];
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const MainLoadingwidget();
    }

    if (_errorMessage != null && _newsList.isEmpty) {
      return MainErrorWidget(
        errorMessage: _errorMessage!,
        onPressed: () => _goToPage(_page),
      );
    }

    if (_newsList.isEmpty) {
      return Center(
        child: Text(
          "No News Item Founded",
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    }

    final showPagination = totalPages > 1;

    return RefreshIndicator(
      onRefresh: () => _goToPage(1),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _newsList.length + (showPagination ? 1 : 0),
        separatorBuilder: (context, index) {
          return SizedBox(height: context.height * 0.02);
        },
        itemBuilder: (context, index) {
          if (index == _newsList.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: _buildPaginationBar(),
            );
          }
          return NewsItems(news: _newsList[index]);
        },
      ),
    );
  }

  Widget _buildPaginationBar() {
    final theme = Theme.of(context);
    final activeBg = theme.splashColor;
    final activeTextColor = theme.scaffoldBackgroundColor;
    final inactiveTextColor =
        theme.textTheme.bodyMedium?.color ?? Colors.grey.shade700;
    final pages = _generatePageNumbers();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: 28,
            onPressed: (_page > 1 && !_isLoading)
                ? () => _goToPage(_page - 1)
                : null,
          ),
          ...pages.map((p) {
            final isCurrent = p == _page;
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: (!_isLoading && !isCurrent) ? () => _goToPage(p) : null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCurrent ? activeBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCurrent ? activeBg : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$p",
                  style: TextStyle(
                    color: isCurrent ? activeTextColor : inactiveTextColor,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            iconSize: 28,
            onPressed: (_page < totalPages && !_isLoading)
                ? () => _goToPage(_page + 1)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
