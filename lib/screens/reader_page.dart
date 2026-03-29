import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'book_selector.dart';
import '../widgets/app_bottom_nav.dart';
import '../nav.dart';
import '../widgets/app_drawer.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  // Mock settings for reader config modal
  bool _isSettingsOpen = false;
  String _currentBook = 'John';
  int _currentChapter = 1;
  String _currentVersion = 'en-kjv';
  
  // Settings state
  double _fontSize = 18;
  String _currentTheme = 'Parchment';

  List<String> _verses = [];
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchChapterVerses();
  }

  Future<void> _fetchChapterVerses() async {
    setState(() {
      _verses.clear();
      _isLoading = true;
      _hasError = false;
    });

    final formattedBook = _currentBook.toLowerCase().replaceAll(' ', '-');
    int verseNum = 1;
    bool hasMore = true;
    final List<String> newVerses = [];

    try {
      // Fetch in small batches to improve loading speed
      while (hasMore) {
        final List<Future<http.Response>> requests = [];
        for (int i = 0; i < 5; i++) {
          final url = 'https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles/$_currentVersion/books/$formattedBook/chapters/$_currentChapter/verses/${verseNum + i}.json';
          requests.add(http.get(Uri.parse(url)));
        }

        final responses = await Future.wait(requests);
        bool anyFailed = false;

        for (var response in responses) {
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            newVerses.add(data['text']);
          } else {
            anyFailed = true;
            break;
          }
        }
        
        if (mounted) {
          setState(() {
            _verses = List.from(newVerses);
          });
        }
        
        if (anyFailed) {
          hasMore = false;
        } else {
          verseNum += 5;
        }
      }
    } catch (e) {
      debugPrint('Error fetching verses: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToNextChapter() {
    final books = bibleBooks.keys.toList();
    final currentIndex = books.indexOf(_currentBook);
    final maxChapters = bibleBooks[_currentBook]!;

    if (_currentChapter < maxChapters) {
      setState(() {
        _currentChapter++;
      });
      _fetchChapterVerses();
    } else if (currentIndex < books.length - 1) {
      setState(() {
        _currentBook = books[currentIndex + 1];
        _currentChapter = 1;
      });
      _fetchChapterVerses();
    }
  }

  void _goToPrevChapter() {
    final books = bibleBooks.keys.toList();
    final currentIndex = books.indexOf(_currentBook);

    if (_currentChapter > 1) {
      setState(() {
        _currentChapter--;
      });
      _fetchChapterVerses();
    } else if (currentIndex > 0) {
      final prevBook = books[currentIndex - 1];
      setState(() {
        _currentBook = prevBook;
        _currentChapter = bibleBooks[prevBook]!;
      });
      _fetchChapterVerses();
    }
  }

  void _showBookSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookSelector(
        initialBook: _currentBook,
        initialChapter: _currentChapter,
        onSelect: (book, chapter) {
          setState(() {
            _currentBook = book;
            _currentChapter = chapter;
          });
          _fetchChapterVerses();
        },
      ),
    );
  }

  String _getBookSubtitle(String book) {
    if (['Matthew', 'Mark', 'Luke', 'John'].contains(book)) {
      return 'Gospel according to $book'.toUpperCase();
    }
    return 'Book of $book'.toUpperCase();
  }

  List<Widget> _buildVerses(BuildContext context) {
    if (_hasError) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Error loading chapter.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        )
      ];
    }

    final widgets = <Widget>[];
    
    for (int i = 0; i < _verses.length; i++) {
      // Highlight verse 3 arbitrarily if John 1
      if (_currentBook == 'John' && _currentChapter == 1 && i == 2) {
        widgets.add(_buildHighlightedVerse(context, i + 1, _verses[i]));
      } else {
        widgets.add(_buildVerse(context, i + 1, _verses[i]));
      }

      // Add flair after verse 5
      if (_currentBook == 'John' && _currentChapter == 1 && i == 4) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Icon(
                Icons.flare,
                size: 36,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ),
          ),
        );
      }
      
      // Add Commentary Teaser after verse 7
      if (_currentBook == 'John' && _currentChapter == 1 && i == 6) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 96, bottom: 32),
            child: Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scholar\'s Note'.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '"The Greek word \'Logos\' implies more than just speech; it signifies the divine reason implicit in the cosmos."',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '— Matthew Henry\'s Commentary',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -16,
                      left: -16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.format_quote,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    if (_isLoading) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (_verses.isEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Text('No verses found.'),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    
    Color surfaceColor;
    Color onSurfaceColor;
    Color surfaceContainerHighestColor;
    Color secondaryContainerColor;
    
    switch (_currentTheme) {
      case 'Midnight':
        surfaceColor = const Color(0xFF1B1C19);
        onSurfaceColor = const Color(0xFFFBF9F4);
        surfaceContainerHighestColor = const Color(0xFF2C2D2B);
        secondaryContainerColor = const Color(0xFF3C3D3B);
        break;
      case 'Paper':
        surfaceColor = Colors.white;
        onSurfaceColor = Colors.black;
        surfaceContainerHighestColor = Colors.grey.shade200;
        secondaryContainerColor = Colors.grey.shade300;
        break;
      case 'Parchment':
      default:
        surfaceColor = const Color(0xFFFBF9F4);
        onSurfaceColor = const Color(0xFF58413F);
        surfaceContainerHighestColor = baseTheme.colorScheme.surfaceContainerHighest;
        secondaryContainerColor = baseTheme.colorScheme.secondaryContainer;
        break;
    }

    final theme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        surfaceContainerHighest: surfaceContainerHighestColor,
        secondaryContainer: secondaryContainerColor,
        // Override outline for borders to look decent in midnight mode
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
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final textTheme = theme.textTheme;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            drawer: const AppDrawer(currentRoute: AppRoutes.home),
            body: Stack(
        children: [
          // Main Scrolling Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 80 + MediaQuery.of(context).padding.top, // Header height + padding
                bottom: 180, // Bottom nav + floating bar padding
                left: 24,
                right: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chapter Header
                      Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 64),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getBookSubtitle(_currentBook),
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.secondary,
                                letterSpacing: 2.0,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chapter $_currentChapter',
                              style: textTheme.displayLarge?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurface,
                                fontSize: 64 * (_fontSize / 18.0),
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              height: 1,
                              width: 48,
                              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),

                      // Scripture Text
                      ..._buildVerses(context),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 64 + MediaQuery.of(context).padding.top,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, // handle status bar
                    left: 24,
                    right: 24,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.85),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF58413F).withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(Icons.menu, color: colorScheme.primary),
                          style: IconButton.styleFrom(
                            hoverColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: colorScheme.primary),
                            onPressed: _goToPrevChapter,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showBookSelector();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$_currentBook $_currentChapter',
                                  style: textTheme.titleLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: colorScheme.onSurface,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: colorScheme.secondary,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right, color: colorScheme.primary),
                            onPressed: _goToNextChapter,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isSettingsOpen = !_isSettingsOpen;
                          });
                        },
                        icon: Icon(Icons.text_fields, color: colorScheme.primary),
                        style: IconButton.styleFrom(
                          hoverColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contextual Reader Bar
          Positioned(
            bottom: 112,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF58413F).withValues(alpha: 0.15),
                          blurRadius: 48,
                          offset: const Offset(0, 24),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'KJV',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.expand_more, size: 16, color: colorScheme.secondary),
                          ],
                        ),
                        Container(
                          height: 24,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark_border, color: colorScheme.onSurfaceVariant, size: 20),
                            const SizedBox(width: 24),
                            Icon(Icons.share_outlined, color: colorScheme.onSurfaceVariant, size: 20),
                            const SizedBox(width: 24),
                            Icon(Icons.play_circle_outline, color: colorScheme.onSurfaceVariant, size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom NavBar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: AppBottomNav(currentRoute: AppRoutes.home),
              ),
            ),
          ),

          // Settings Overlay
          if (_isSettingsOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isSettingsOpen = false;
                  });
                },
                child: Container(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {}, // Prevent tap from closing when clicking inside
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 48,
                                  height: 6,
                                  margin: const EdgeInsets.only(bottom: 32),
                                  decoration: BoxDecoration(
                                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                              Text(
                                'Typography Settings'.toUpperCase(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.secondary,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Font Scale Slider
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.text_fields, size: 16, color: colorScheme.onSurface),
                                    Expanded(
                                      child: Slider(
                                        value: _fontSize,
                                        min: 12,
                                        max: 24,
                                        activeColor: colorScheme.primary,
                                        inactiveColor: colorScheme.outlineVariant,
                                        onChanged: (val) {
                                          setState(() {
                                            _fontSize = val;
                                          });
                                        },
                                      ),
                                    ),
                                    Icon(Icons.text_fields, size: 24, color: colorScheme.onSurface),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Themes
                              Row(
                                children: [
                                  _buildThemeOption(context, 'Parchment', const Color(0xFFFBF9F4), const Color(0xFF58413F), _currentTheme == 'Parchment'),
                                  const SizedBox(width: 16),
                                  _buildThemeOption(context, 'Midnight', const Color(0xFF1B1C19), const Color(0xFFFBF9F4), _currentTheme == 'Midnight'),
                                  const SizedBox(width: 16),
                                  _buildThemeOption(context, 'Paper', Colors.white, Colors.black, _currentTheme == 'Paper'),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
        },
      ),
    );
  }

  Widget _buildVerse(BuildContext context, int number, String text) {
    final theme = Theme.of(context);
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
                fontSize: _fontSize,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedVerse(BuildContext context, int number, String text) {
    final theme = Theme.of(context);
    return Container(
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
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 16),
            child: Row(
              children: [
                _buildActionBtn(context, Icons.auto_awesome, 'Study'),
                const SizedBox(width: 16),
                _buildActionBtn(context, Icons.edit_note, 'Note'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
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


  Widget _buildThemeOption(BuildContext context, String label, Color bg, Color text, bool isSelected) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentTheme = label;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF58413F) : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
