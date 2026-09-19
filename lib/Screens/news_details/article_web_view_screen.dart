import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/model/news.dart';
import 'package:news_app/cubits/favorites/favorites_cubit.dart';
import 'package:news_app/cubits/favorites/favorites_state.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebViewScreen extends StatefulWidget {
  final News? news;
  const ArticleWebViewScreen({super.key, this.news});

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;
  News? _resolvedNews;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _loadingProgress = 0;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _loadingProgress = 100;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted && (error.isForMainFrame ?? true)) {
              setState(() {
                _hasError = true;
              });
            }
          },
        ),
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _resolvedNews = widget.news ??
          (ModalRoute.of(context)?.settings.arguments as News?);
      final urlString = _resolvedNews?.url;
      if (urlString != null && urlString.isNotEmpty) {
        final uri = Uri.tryParse(urlString);
        if (uri != null) {
          _controller.loadRequest(uri);
        }
      }
      _initialized = true;
    }
  }

  Future<void> _openExternal() async {
    final urlString = _resolvedNews?.url;
    if (urlString == null || urlString.isEmpty) return;
    final uri = Uri.tryParse(urlString);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final news = _resolvedNews;
    final title = news?.source?.name ?? news?.title ?? l10n?.view_Full_Articel ?? "Article";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18,
              ),
        ),
        actions: [
          // Refresh page button
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Refresh",
            onPressed: () {
              _controller.reload();
            },
          ),
          // Bookmark toggle button
          if (news != null)
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                final isFav = state.favorites.any((item) =>
                    (item.url != null && item.url == news.url) ||
                    (item.title != null && item.title == news.title));
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.bookmark : Icons.bookmark_border_rounded,
                    color: isFav ? Colors.amber : null,
                  ),
                  tooltip: isFav ? "Remove bookmark" : "Save bookmark",
                  onPressed: () async {
                    final added = await context.read<FavoritesCubit>().toggleFavorite(news);
                    if (context.mounted && l10n != null) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: Text(
                            added
                                ? l10n.added_to_bookmarks
                                : l10n.removed_from_bookmarks,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          // Open in external browser fallback
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded),
            tooltip: "Open in browser",
            onPressed: _openExternal,
          ),
        ],
        bottom: _loadingProgress < 100
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3.0),
                child: LinearProgressIndicator(
                  value: _loadingProgress / 100.0,
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).splashColor,
                  minHeight: 3.0,
                ),
              )
            : null,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_hasError)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Theme.of(context).splashColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Unable to load webpage",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).splashColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _controller.reload();
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Try Again"),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _openExternal,
                    icon: const Icon(Icons.open_in_browser_rounded),
                    label: const Text("Open in External Browser"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
