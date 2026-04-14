import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bible_app/auth_provider.dart';
import 'package:bible_app/theme_provider.dart';
import 'package:bible_app/nav.dart';
import 'package:bible_app/widgets/app_bottom_nav.dart';

import 'package:bible_app/widgets/app_drawer.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isGuest = context.watch<AuthProvider>().isGuest;
    
    return Scaffold(
      extendBody: true,
      backgroundColor: colorScheme.surface,
      drawer: isGuest ? null : const AppDrawer(currentRoute: AppRoutes.search),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.search),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme, colorScheme, isGuest),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: 24.0,
                left: 24.0,
                right: 24.0,
                bottom: MediaQuery.of(context).padding.bottom + 160.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrendingSearches(context, theme, colorScheme),
                  const SizedBox(height: 48),
                  _buildExploreCategories(context, theme, colorScheme),
                  const SizedBox(height: 48),
                  _buildRecentInsights(context, theme, colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme, ColorScheme colorScheme, bool isGuest) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 64,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
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
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Holy Bible',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                color: colorScheme.onSurface,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isGuest)
                  IconButton(
                    icon: Icon(
                      theme.brightness == Brightness.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: colorScheme.primary,
                    ),
                    onPressed: () {
                      final provider = context.read<ThemeProvider>();
                      provider.setThemeMode(
                        theme.brightness == Brightness.dark
                            ? ThemeMode.light
                            : ThemeMode.dark,
                      );
                    },
                    tooltip: 'Toggle Theme',
                  ),
                IconButton(
                  icon: Icon(Icons.logout, color: colorScheme.error),
                  onPressed: () {
                    context.read<AuthProvider>().logout();
                    context.go(AppRoutes.auth);
                  },
                  tooltip: 'Log Out',
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: isGuest ? const SizedBox.shrink() : Material(
                    color: Colors.transparent,
                    child: Builder(
                      builder: (context) => InkWell(
                        customBorder: const CircleBorder(),
                        hoverColor: colorScheme.surfaceContainerHighest,
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Icon(
                          Icons.menu_book,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0, top: 16.0),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: colorScheme.outline,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search verses, parables, or people...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline.withValues(alpha: 0.6),
                        fontFamily: 'Manrope',
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.mic,
                  color: colorScheme.outline.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSearches(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final searches = ['Anxiety', 'Hope', 'Forgiveness', 'Grace', 'Strength'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 24.0),
          child: Text(
            'TRENDING SEARCHES',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: searches.map((text) {
            return InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3EE), // surface-container-low approx
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'Manrope',
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExploreCategories(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'EXPLORE CATEGORIES',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            // Row 1: People of the Bible
            _buildCategoryCard(
              context: context,
              theme: theme,
              height: 192,
              title: 'People of the Bible',
              subtitle: 'DISCOVER',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAqIBzSinE7Y5I0aVD0GyOk5QBiqrI1b-uIxVh-US2MOXjISJEdXThKFu-K7ri5e0OR-2lPSW5tyMdoxMfug2ZWUVDJ2kvHonRVm19px2Geori5UtVvQQJrzwTsFmIGFtgNIHkL27vs8skR-rWNkofYgDAi0HFLGxFWBlAnHqa97cfYv1HIWM_CDyWc4cF2-9iPaHoQEjsBT0YMpCMRj1I0U3aQ5swA141jW2FgQT80Wddgkzyh9Df2h6kROXzUP09f0wiT1g8ueyI',
              gradientColors: [colorScheme.primary.withValues(alpha: 0.8), Colors.transparent],
            ),
            const SizedBox(height: 16),
            
            // Row 2: Miracles & Parables
            Row(
              children: [
                Expanded(
                  child: _buildCategoryCard(
                    context: context,
                    theme: theme,
                    height: 192,
                    title: 'Divine\nMiracles',
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA0IGFVFQia2oHwRfwQSJLSOkalpz5HZ_jVh2YqqvMYU5UC8AFWnhgxS5bx06650dHF41XNjpT1lEr5SnDX4A6Fl3tdjScjlpQrGYCKziDNX2-kDOVwz4UyRj7eU7QoRsp_AHg4vCIdRdaQrBU4TpZ97x6rWQ7LplicwcWwzHypvvzfdUZ74lnW7F8vH5IKfiHyG-hrQzRZyWYxbR0MlLVSn-ZoyU6PpOnpQeBjhEr64n9dgTAC6bOhoYU49UO3DjQqsHPZRGQns14',
                    gradientColors: [const Color(0xFF1B1C19).withValues(alpha: 0.6), Colors.transparent],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCategoryCard(
                    context: context,
                    theme: theme,
                    height: 192,
                    title: 'Wisdom\nParables',
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDn_KGATluPHeBmCTISqVlDnddLR_n5g6lHhSO-B87VdL7B_7A_Va20B5QSAGOCWL-wzraoq0jOFLh4miadzSvzmbqcP6vNFqhmTUOgl8i5cZBD9hmpzH7rUDThUe4KcSrrwaDjs53YSjzYJg0tz7hWLBAcNZ5YoXXz0ySkfeqJCGmFPi3-GCeub07ckzyBu1QIy2OHgG3IXJqgpp59x6M3HoLrJg0zRk1XZWtVvpvSc0Unwp4-ln6D8y-I1zDFkEkfibNcnQ8ClLc',
                    gradientColors: [colorScheme.secondary.withValues(alpha: 0.7), Colors.transparent],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Row 3: Sacred Geography
            _buildCategoryCard(
              context: context,
              theme: theme,
              height: 160,
              title: 'Sacred Geography',
              titleCentered: true,
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC16aKeDzQ9cx7cFATDk30qWgHEG75_QatvxkwXDSFQDhD-r9ui4jokREhMs4Q_pYRhsVpZei24DKfQd8_bIn8nEH3sPeOI6Nuuy5AoQyluVb3z21DheXLBXchsPJlWeg81gLY3QPJqhJ8uqsM0ICTm1jvr5GwwhqEvOQSjZPttoX_O7TIy16MhEcBF6c-p3oRd9SShRajC--iPAF7YDUaCHTj66YD8d-IjebcdTrsAyM9-k75csA_DwP9gNxsHn3IfSODrkav_cP4',
              gradientColors: [colorScheme.surface.withValues(alpha: 0.2), colorScheme.surface.withValues(alpha: 0.2)],
            ),
            const SizedBox(height: 16),
            
            // Row 4: Interactive Journey
            Material(
              color: const Color(0xFFEAE8E3), // surface-container-high approx
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  context.push(
                    AppRoutes.exploreCategory,
                    extra: {
                      'title': 'Interactive Journey',
                      'subtitle': 'Trace the steps of the Apostles',
                      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC16aKeDzQ9cx7cFATDk30qWgHEG75_QatvxkwXDSFQDhD-r9ui4jokREhMs4Q_pYRhsVpZei24DKfQd8_bIn8nEH3sPeOI6Nuuy5AoQyluVb3z21DheXLBXchsPJlWeg81gLY3QPJqhJ8uqsM0ICTm1jvr5GwwhqEvOQSjZPttoX_O7TIy16MhEcBF6c-p3oRd9SShRajC--iPAF7YDUaCHTj66YD8d-IjebcdTrsAyM9-k75csA_DwP9gNxsHn3IfSODrkav_cP4', // Placeholder map-like image
                    },
                  );
                },
                child: Container(
                  height: 160,
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.map, color: colorScheme.secondary, size: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interactive Journey',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Trace the steps of the Apostles',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'Manrope',
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required ThemeData theme,
    required double height,
    required String title,
    String? subtitle,
    required String imageUrl,
    required List<Color> gradientColors,
    bool titleCentered = false,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: gradientColors,
              ),
            ),
          ),
          if (titleCentered)
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            )
          else
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (subtitle != null) ...[
                    Text(
                      subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.push(
                      AppRoutes.exploreCategory,
                      extra: {
                        'title': title,
                        'subtitle': subtitle,
                        'imageUrl': imageUrl,
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentInsights(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'RECENT INSIGHTS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildInsightCard(
          context: context,
          theme: theme,
          colorScheme: colorScheme,
          reference: 'PHILIPPIANS 4:6-7',
          verse: '“Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.”',
          tag: 'PEACE THAT TRANSCENDS UNDERSTANDING',
        ),
        const SizedBox(height: 24),
        _buildInsightCard(
          context: context,
          theme: theme,
          colorScheme: colorScheme,
          reference: 'PSALM 34:18',
          verse: '“The Lord is close to the brokenhearted and saves those who are crushed in spirit.”',
          tag: 'COMFORT FOR THE WEARY',
        ),
        const SizedBox(height: 24),
        _buildInsightCard(
          context: context,
          theme: theme,
          colorScheme: colorScheme,
          reference: 'MATTHEW 11:28',
          verse: '“Come to me, all you who are weary and burdened, and I will give you rest.”',
          tag: 'INVITATION TO REST',
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String reference,
    required String verse,
    required String tag,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white, // surface-container-lowest
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF58413F).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reference,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              Icon(
                Icons.bookmark_border,
                color: colorScheme.outlineVariant,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            verse,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurface,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 1,
                width: 32,
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tag,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
