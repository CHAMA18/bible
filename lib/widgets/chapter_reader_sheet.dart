import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:bible_app/settings_provider.dart';
import 'dart:ui';

class ChapterReaderSheet extends StatefulWidget {
  final String book;
  final int chapter;
  final int highlightedVerse;

  const ChapterReaderSheet({
    super.key,
    required this.book,
    required this.chapter,
    required this.highlightedVerse,
  });

  @override
  State<ChapterReaderSheet> createState() => _ChapterReaderSheetState();
}

class _ChapterReaderSheetState extends State<ChapterReaderSheet> {
  List<String> _verses = [];
  bool _isLoading = true;
  bool _hasError = false;
  final GlobalKey _highlightedVerseKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchChapter();
  }

  Future<void> _fetchChapter() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final translationId = context.read<SettingsProvider>().currentTranslationId;
      final query = '${widget.book} ${widget.chapter}';
      var url = 'https://bible-api.com/${Uri.encodeComponent(query)}?translation=$translationId';
      var response = await http.get(Uri.parse(url));

      // Fallback to KJV if the selected translation is not supported by the free API
      if (response.statusCode != 200 && translationId != 'kjv') {
        url = 'https://bible-api.com/${Uri.encodeComponent(query)}?translation=kjv';
        response = await http.get(Uri.parse(url));
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final versesData = data['verses'] as List;
        final verses = versesData.map((v) => v['text'].toString().trim()).toList();
        
        if (mounted) {
          setState(() {
            _verses = verses;
            _isLoading = false;
          });
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_highlightedVerseKey.currentContext != null) {
              Scrollable.ensureVisible(
                _highlightedVerseKey.currentContext!,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
                alignment: 0.1, // Align near the top
              );
            }
          });
        }
      } else {
        throw Exception('Failed to load chapter');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildVerse(BuildContext context, int number, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                number.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                fontStyle: FontStyle.italic,
                fontSize: 18,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedVerse(BuildContext context, int number, String text, ThemeData theme) {
    return Container(
      key: _highlightedVerseKey,
      margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      transform: Matrix4.translationValues(-16, 0, 0),
      padding: const EdgeInsets.only(left: 14, top: 16, bottom: 16, right: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    number.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    fontStyle: FontStyle.italic,
                    height: 1.8,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 16),
            child: Row(
              children: [
                _buildActionBtn(context, Icons.auto_awesome, 'Study', theme),
                const SizedBox(width: 16),
                _buildActionBtn(context, Icons.edit_note, 'Note', theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, IconData icon, String label, ThemeData theme) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.secondary),
          const SizedBox(width: 4),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              letterSpacing: 2.0,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final isDark = baseTheme.brightness == Brightness.dark;
    
    // Borrow ReaderPage styling (Parchment/Midnight)
    final surfaceColor = isDark ? const Color(0xFF1B1C19) : const Color(0xFFFBF9F4);
    final onSurfaceColor = isDark ? const Color(0xFFFBF9F4) : const Color(0xFF58413F);
    final surfaceContainerHighestColor = isDark ? const Color(0xFF2C2D2B) : baseTheme.colorScheme.surfaceContainerHighest;
    final secondaryContainerColor = isDark ? const Color(0xFF3C3D3B) : baseTheme.colorScheme.secondaryContainer;

    final theme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        surfaceContainerHighest: surfaceContainerHighestColor,
        secondaryContainer: secondaryContainerColor,
        outlineVariant: onSurfaceColor.withValues(alpha: 0.2),
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: onSurfaceColor,
        displayColor: onSurfaceColor,
      ),
    );
    
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final currentTheme = Theme.of(context);
          final colorScheme = currentTheme.colorScheme;
          
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.98),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          height: 4,
                          width: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Book of ${widget.book}'.toUpperCase(),
                                    style: currentTheme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.secondary,
                                      letterSpacing: 2.0,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Chapter ${widget.chapter}',
                                    style: currentTheme.textTheme.headlineMedium?.copyWith(
                                      fontFamily: 'Playfair Display',
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Divider(height: 32, color: colorScheme.outlineVariant),
                        
                        // Content
                        Expanded(
                          child: _isLoading && _verses.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : _hasError && _verses.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                                      const SizedBox(height: 16),
                                      Text('Failed to load chapter', style: currentTheme.textTheme.titleMedium),
                                      TextButton(
                                        onPressed: _fetchChapter,
                                        child: const Text('Try Again'),
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _verses.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final text = entry.value;
                                      final verseNum = index + 1;
                                      final isHighlighted = verseNum == widget.highlightedVerse;
                                      
                                      if (isHighlighted) {
                                        return _buildHighlightedVerse(context, verseNum, text, currentTheme);
                                      } else {
                                        return _buildVerse(context, verseNum, text, currentTheme);
                                      }
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
