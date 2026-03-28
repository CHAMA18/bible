import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bible_app/theme.dart';

class BibleTranslation {
  final String id;
  final String name;
  final String abbreviation;
  final String language;
  final String description;
  final bool isDownloaded;
  final String category;

  const BibleTranslation({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.language,
    required this.description,
    required this.category,
    this.isDownloaded = false,
  });
}

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  String _selectedId = 'niv';
  String _searchQuery = '';
  
  final List<BibleTranslation> _translations = [
    const BibleTranslation(
      id: 'niv',
      name: 'New International Version',
      abbreviation: 'NIV',
      language: 'English',
      description: 'Accurate, readable, and clear. The most widely read modern English Bible.',
      category: 'Popular',
      isDownloaded: true,
    ),
    const BibleTranslation(
      id: 'esv',
      name: 'English Standard Version',
      abbreviation: 'ESV',
      language: 'English',
      description: 'An essentially literal translation that emphasizes word-for-word accuracy.',
      category: 'Popular',
      isDownloaded: true,
    ),
    const BibleTranslation(
      id: 'kjv',
      name: 'King James Version',
      abbreviation: 'KJV',
      language: 'English',
      description: 'The historic and poetic English translation from 1611.',
      category: 'Classic',
      isDownloaded: false,
    ),
    const BibleTranslation(
      id: 'nlt',
      name: 'New Living Translation',
      abbreviation: 'NLT',
      language: 'English',
      description: 'A clear and contemporary English translation, great for everyday reading.',
      category: 'Popular',
      isDownloaded: false,
    ),
    const BibleTranslation(
      id: 'csb',
      name: 'Christian Standard Bible',
      abbreviation: 'CSB',
      language: 'English',
      description: 'A highly readable, highly reliable translation.',
      category: 'Modern',
      isDownloaded: false,
    ),
    const BibleTranslation(
      id: 'nasb',
      name: 'New American Standard Bible',
      abbreviation: 'NASB',
      language: 'English',
      description: 'Strict adherence to literal translation.',
      category: 'Modern',
      isDownloaded: false,
    ),
    const BibleTranslation(
      id: 'amp',
      name: 'Amplified Bible',
      abbreviation: 'AMP',
      language: 'English',
      description: 'Expands words to reveal deeper meaning.',
      category: 'Study',
      isDownloaded: false,
    ),
    const BibleTranslation(
      id: 'msg',
      name: 'The Message',
      abbreviation: 'MSG',
      language: 'English',
      description: 'A contemporary rendering from the original languages.',
      category: 'Study',
      isDownloaded: false,
    ),
    const BibleTranslation(
      id: 'rvr60',
      name: 'Reina-Valera 1960',
      abbreviation: 'RVR60',
      language: 'Español',
      description: 'La Biblia en español más leída y amada.',
      category: 'International',
      isDownloaded: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final filteredTranslations = _translations.where((t) {
      final query = _searchQuery.toLowerCase();
      return t.name.toLowerCase().contains(query) ||
             t.abbreviation.toLowerCase().contains(query) ||
             t.language.toLowerCase().contains(query);
    }).toList();

    // Group by category
    final grouped = <String, List<BibleTranslation>>{};
    for (var t in filteredTranslations) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }
    
    // Sort categories (Popular first, etc.)
    final sortedCategories = grouped.keys.toList()..sort((a, b) {
      if (a == 'Popular') return -1;
      if (b == 'Popular') return 1;
      return a.compareTo(b);
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: const Text('Translation'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildSearchBar(colorScheme),
              ),
            ),
          ),
          if (filteredTranslations.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No translations found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = sortedCategories[index];
                  final items = grouped[category]!;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Text(
                          category.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...items.map((t) => _buildTranslationCard(t, theme, colorScheme)),
                      if (index == sortedCategories.length - 1)
                        const SizedBox(height: 32),
                    ],
                  );
                },
                childCount: sortedCategories.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return TextField(
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'Search translations or languages...',
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withValues(alpha: 0.5)),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }

  Widget _buildTranslationCard(BibleTranslation translation, ThemeData theme, ColorScheme colorScheme) {
    final isSelected = translation.id == _selectedId;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedId = translation.id;
          });
          // Also can auto-pop after selection if needed
          // Future.delayed(const Duration(milliseconds: 300), () {
          //   if (mounted) context.pop();
          // });
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAbbreviationBadge(translation, isSelected, colorScheme, theme),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            translation.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (translation.isDownloaded) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.cloud_done_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      translation.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      child: Text(
                        translation.language,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('check'),
                        color: colorScheme.primary,
                        size: 28,
                      )
                    : (!translation.isDownloaded
                        ? IconButton(
                            key: const ValueKey('download'),
                            icon: const Icon(Icons.cloud_download_outlined),
                            color: colorScheme.primary,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // Handle download
                            },
                          )
                        : const SizedBox(
                            width: 28,
                            key: ValueKey('empty'),
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbbreviationBadge(BibleTranslation translation, bool isSelected, ColorScheme colorScheme, ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected 
            ? colorScheme.primary 
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Text(
        translation.abbreviation,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: isSelected 
              ? colorScheme.onPrimary 
              : colorScheme.primary,
        ),
      ),
    );
  }
}
