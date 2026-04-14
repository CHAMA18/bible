import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../theme_provider.dart';
import '../nav.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_drawer.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isGuest = context.watch<AuthProvider>().isGuest;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      extendBodyBehindAppBar: true,
      drawer: isGuest ? null : const AppDrawer(currentRoute: AppRoutes.library),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: colorScheme.surface.withValues(alpha: 0.85),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: isGuest ? null : IconButton(
                icon: Icon(Icons.menu, color: colorScheme.primary),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              actions: [
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
                IconButton(
                  icon: Icon(Icons.menu_book, color: colorScheme.primary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 90,
              bottom: 180, // space for nav and floating bar
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 48),
                _buildMyVersions(context),
                const SizedBox(height: 48),
                _buildRecommended(context),
                const SizedBox(height: 48),
                _buildCategories(context),
                const SizedBox(height: 80), // extra padding for bottom elements
              ],
            ),
          ),
          // Contextual Reader Bar
          Positioned(
            bottom: 160, // above bottom nav
            left: 0,
            right: 0,
            child: Center(
              child: _buildContextualBar(context),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.library),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search versions, languages, or publishers...',
          hintStyle: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
        style: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMyVersions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Versions',
                  style: textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AVAILABLE OFFLINE',
                  style: textTheme.labelSmall?.copyWith(
                    letterSpacing: 2.0,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.settings, size: 14, color: colorScheme.secondary),
              label: Text(
                'MANAGE',
                style: textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            if (isWide) {
              return Row(
                children: [
                  Expanded(flex: 2, child: _buildActiveVersionCard(context)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildSecondaryVersionCard(context)),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildActiveVersionCard(context),
                  const SizedBox(height: 16),
                  _buildSecondaryVersionCard(context),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActiveVersionCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface, // nearest to surface-container-lowest
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.check_circle, color: colorScheme.secondary),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENTLY READING',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3.0,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'English Standard\nVersion',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'An essentially literal translation of the Bible in contemporary English, emphasizing word-for-word accuracy and literary excellence.',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '42.8 MB • Updated 2 days ago',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryVersionCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3), // surface-container-low
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KJV',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'King James Version',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48), // Spacer equivalent
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.download_done, color: colorScheme.onSurfaceVariant),
              Text(
                'USE',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommended(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final recommendedItems = [
      {
        'title': 'NIV',
        'desc': 'New International Version. Balanced between word-for-word and thought-for-thought.',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD88CCd0Rte6s5MwAz1miAPzgP2m1f0FHPHd-wBw_v5_-ttZLjuUk3lKnJNnt1mxMwckC74yJ4NpFx4XbKJLm1QhaBoCQR0TahB3BkyL3ufvyKjMRxVr92aPM2UvzCwF0NN8zCrHhRujfZjCwudz3jaKC6UDYCzhOO5yf0yKzofsisFKtSYhnOP2M9Nhf8zqwzHLJhtuMDoM44fEHFBGioOn1roWQxjuUNTgSCpag3BwnkLzUleC5f99R0IcM2ZBT-MZa20YKv-ZoE',
      },
      {
        'title': 'NASB 2020',
        'desc': 'New American Standard Bible. Renowned for its strict adherence to original languages.',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBl-j92fwgGk3vCMARaUqYnrbQ8HCoEwtnT5IdeXEWB07Fb6841D1fACN3j8xvzgsk689WqXIfk6p5fFV1-80VyFbRNfSUAG-WdBMCwi5LWcFbZwLpw0PkzGPvqZZfBjLoS4g46JxfEUIPcYDGeC_InX2VrfOJi2hEI6Mzb_N9tJPAwDgC11KMaAr9RrOdZLpB8xnCkgfFY6TQevjasnqt53QUILQXBIZSXOKoNfbauOaMs-C48ajHEXWmR0mnNxhGyIzHNqaEQ2YY',
      },
      {
        'title': 'CSB',
        'desc': 'Christian Standard Bible. Optimal blend of accuracy and readability for study.',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCrnvsxdevUQWGc0h2nzxxLhR61psi6INWpVKpc4Da5auw5swsVZLTRCIpfiRcjcJ4GaSToi3P5yn5UGcfnMjczqXJnHFV-l9PdmbmNjHmL7Ol464_YQ_qX4sTIYlmx3ZrK-bQ-r5YTOBHCzWymuFcVIzwON8adZWTpc4WKSKxbR1g6nitXxHnjDg2wxUMDCA_0igHyufIqFipMGLC-eUJJrIjv18v2S0GFGJfckcj_0lbj7GRCF1DpSBgsVODhcPCLU7AnmEX9cG8',
      },
      {
        'title': 'NLT',
        'desc': 'New Living Translation. Easy to understand and perfect for devotional reading.',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAY6_2OgANLK-2j8GgFEBntuG6e8qT2_HCbDpcAruCrKpW8rHbi4i-w1tMV7W4TAxXUlPMCx5rdKdVQci5FiDzAUNEmz4n9suMN70-Yn8np8y2iiSIGuOJ1vldpDfJFjPoqfDIzwrOYLDfXfH3lWT3JY9JeJFxFgjTcJpF7hbcxYEK3Nip9bhcje_J-zTdqBv7_AeQesemn6P9zEVK7Dd-Zg-yheRVjzOcjBaFeR2SQP3VMnC-JuV6zzyr7cnKNnxYm3tULgVXnhhc',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for You',
          style: textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 32),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 4 : (constraints.maxWidth > 400 ? 2 : 1),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isWide ? 0.6 : (constraints.maxWidth > 400 ? 0.65 : 1.2),
              ),
              itemCount: recommendedItems.length,
              itemBuilder: (context, index) {
            final item = recommendedItems[index];
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['title']!,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item['desc']!,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primaryContainer,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'DOWNLOAD',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  ],
);
  }

  Widget _buildCategories(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    
    final classicTranslations = [
      {'title': 'Douay-Rheims (DRA)', 'subtitle': '1609 AD • Traditional Catholic'},
      {'title': 'Young\'s Literal (YLT)', 'subtitle': '1862 AD • Strict Literalism'},
      {'title': 'Geneva Bible (1599)', 'subtitle': '1599 AD • Historical Reformed'},
    ];
    
    final modernScholarly = [
      {'title': 'NET Bible', 'subtitle': '2019 • 60,000+ Translator Notes'},
      {'title': 'Amplified (AMP)', 'subtitle': '2015 • Word expansion & detail'},
      {'title': 'Lexham English (LEB)', 'subtitle': '2012 AD • Transparent Accuracy'},
    ];

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildCategoryList(context, 'Classic Translations', classicTranslations),
          ),
          const SizedBox(width: 64),
          Expanded(
            child: _buildCategoryList(context, 'Modern Scholarly', modernScholarly),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryList(context, 'Classic Translations', classicTranslations),
          const SizedBox(height: 48),
          _buildCategoryList(context, 'Modern Scholarly', modernScholarly),
        ],
      );
    }
  }

  Widget _buildCategoryList(BuildContext context, String title, List<Map<String, String>> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 24),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle']!,
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.download,
                      color: colorScheme.outlineVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildContextualBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContextualItem(context, Icons.language, 'ENGLISH'),
            const SizedBox(width: 16),
            Container(width: 1, height: 16, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            const SizedBox(width: 16),
            _buildContextualItem(context, Icons.sort_by_alpha, 'SORT: RECENT'),
            const SizedBox(width: 16),
            Container(width: 1, height: 16, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            const SizedBox(width: 16),
            _buildContextualItem(context, Icons.cloud_download, '3 ACTIVE DOWNLOADS'),
          ],
        ),
      ),
    );
  }

  Widget _buildContextualItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorScheme.secondary),
        const SizedBox(width: 8),
        Text(
          text,
          style: textTheme.labelSmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
