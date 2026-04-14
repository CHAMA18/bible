import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bible_app/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../nav.dart';
import '../auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/chapter_reader_sheet.dart';

import 'package:share_plus/share_plus.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isGuest = context.watch<AuthProvider>().isGuest;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: isGuest ? null : const AppDrawer(currentRoute: AppRoutes.home),
      body: Stack(
        children: [
          // Main Scrolling Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 80 + MediaQuery.of(context).padding.top,
                bottom: 120, // Bottom nav padding
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroSection(context),
                        const SizedBox(height: 48),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 800) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildReadingJourney(context),
                                  ),
                                  const SizedBox(width: 48),
                                  Expanded(
                                    flex: 1,
                                    child: _buildRecentPath(context),
                                  ),
                                ],
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReadingJourney(context),
                                const SizedBox(height: 48),
                                _buildRecentPath(context),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 48),
                        _buildScholarlyCircles(context),
                        const SizedBox(height: 48),
                        _buildDailyDevotion(context),
                      ],
                    ),
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
                    top: MediaQuery.of(context).padding.top,
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
                      Row(
                        children: [
                          if (!isGuest)
                            Builder(
                              builder: (context) => IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: Icon(Icons.menu, color: colorScheme.primary),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => context.push(AppRoutes.translation),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    context.watch<SettingsProvider>().currentTranslationAbbreviation,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  Icon(Icons.expand_more, size: 16, color: colorScheme.primary),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.notifications_none, color: colorScheme.primary),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.menu_book, color: colorScheme.primary),
                            onPressed: () {
                              context.go(AppRoutes.bible);
                            },
                          ),
                        ],
                      ),
                    ],
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
                child: const AppBottomNav(currentRoute: AppRoutes.home),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
        image: const DecorationImage(
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBn5MUixl3yxBnHo9FHsFg-89FOVK-49xCP3q5gzNgQzSA4e6lXqHKiOT08rhzIMP8uZnd35BNw-UuOrPSrmJZQbM82pHEbnTo6_vJMY0WPqKFF-qBHaMKVveUI_9i0awMKZThiFGgBCnYcl6i5oEaJBmPzXCDV5NUXkLxqN4Lo2ocWIde2cJ5TkwN7tmFbIfQxA-AjE3b-PolHW6mEvJpRImZl0Crn0zLDK18YKmh5hzw3iGN9JTNHeWyxAdcBgPKCCOZ5CBEPcrw',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'VERSE OF THE DAY',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.secondaryContainer,
                letterSpacing: 4.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '"Thy word is a lamp unto my feet, and a light unto my path."',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '— Psalm 119:105',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.8),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      builder: (context) => const ChapterReaderSheet(
                        book: 'Psalms',
                        chapter: 119,
                        highlightedVerse: 105,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    'READ FULL CHAPTER',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      Share.share(
                        '"Thy word is a lamp unto my feet, and a light unto my path."\n— Psalm 119:105',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingJourney(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Your Reading Journey',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () => context.push(AppRoutes.readingPlans),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  'VIEW ALL PLANS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF58413F).withValues(alpha: 0.08),
                blurRadius: 48,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT PLAN',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'The Wisdom of Proverbs',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Day 14',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'OF 30 DAYS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.46,
                  minHeight: 6,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '46% COMPLETE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    '16 DAYS LEFT',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.play_circle_fill, color: colorScheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Listen to Proverbs 14',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '4:12',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.menu_book, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Read Today's Word",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPath(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Path',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildRecentItem(
          context,
          icon: Icons.bookmark,
          title: 'Romans 8:28',
          subtitle: 'READ 2 HOURS AGO',
          iconBg: colorScheme.secondaryContainer,
          iconColor: colorScheme.onSecondaryContainer,
        ),
        const SizedBox(height: 16),
        _buildRecentItem(
          context,
          icon: Icons.menu_book,
          title: 'Isaiah 40',
          subtitle: 'READ YESTERDAY',
          iconBg: colorScheme.surfaceContainerHighest,
          iconColor: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        _buildRecentItem(
          context,
          icon: Icons.history,
          title: 'Matthew 5-7',
          subtitle: 'READ 3 DAYS AGO',
          iconBg: colorScheme.surfaceContainerHighest,
          iconColor: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildRecentItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScholarlyCircles(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Scholarly Circles',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Scholarly Circles feature coming soon...'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'JOIN THE CONVERSATION',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 420,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildCircleCard(
                context,
                tag: 'GREEK CONTEXT',
                title: 'Origins of Logos',
                description: 'Exploring the philosophical and theological roots of John 1:1.',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABmsTDLbdQkrqSei7ba6PkZtV9ch9rV_kkMDbFs6hOT_xuZy-cwNT0XNvEDN6vHQ1qyaLuMWRdxFLKwHW_4uNYxvGtjaRXYxzFdGXBL5coUPs6HTXegjCxgJuDcIzi0w4AtICDWiRB9lGug_IXLzmHtUhTzkaL-gwq6WRxxkkrNGofKRI4b85I74HAtPF2zP_K-dzVXurPXQ-sVHtG5W4hNDt12iR9fr3f3rjDXfozNy5jzYp3tHTwBaJshBtqt4U_coQC2KO20JY',
                count: '+12',
                isHighlighted: true,
              ),
              const SizedBox(width: 24),
              _buildCircleCard(
                context,
                tag: 'POETIC LITERATURE',
                title: 'Psalms of Ascent',
                description: 'A daily meditative journey through the songs of pilgrimage.',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAoe1FjXlb3tdELO3lQAvc7v-9JuwmuNT6P8A2gL4f-Hdo-UjqZa7hejvX5VzSm5lPSgezoTUEPS83zftv3DZjJOjRO2IboTQj3eLqrAkqtE_qQRpML4viVdLibWED_l0dKMmT-zzxCpkI1o9UfBfX_wjMIbNwZx73rdXtkB1LhZUX-auuLyK6fdnbbPbZpKCljLKUykk0XDZUNFtJXtVMtgZzDW4nMY6O34XyIfcP_KfDwxdKvXWXwyOs6CE__DAa6Uc7VuzOvrL8',
                count: '+4',
                isHighlighted: false,
              ),
              const SizedBox(width: 24),
              _buildCircleCard(
                context,
                tag: 'HISTORICAL CONTEXT',
                title: 'Dead Sea Scrolls',
                description: 'Deep dive into the archeological history of the Qumran texts.',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB2f_4HOySCm6SSrsCHTIPNYUyg6U0pjcoqqfk-AXcSN3rQ-cwgrHoCfZQ2_8rTWz_ocPPGf7hPk-2IZZUsfbufZ-ILmKIz5ubYQD-7QhuRS7fsqSfebT_AM9PWwRNBEBPV4YDdNqdbYRWGeEk-FUKlH5Wj6o8dW-0MQYLjNBmdClLYsjyrK1jtbxjEVutvKFAW9VhelO1SqyiOBxPuPeBHmuL1_B33xShDbIcXF_KdNihmc97qid-03oNjrnPY2JhLk9AX-kaJ1QI',
                count: '+8',
                isHighlighted: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleCard(
    BuildContext context, {
    required String tag,
    required String title,
    required String description,
    required String imageUrl,
    required String count,
    required bool isHighlighted,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isHighlighted ? colorScheme.secondaryContainer : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isHighlighted ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildAvatar(Colors.grey.shade300),
                        Transform.translate(offset: const Offset(-8, 0), child: _buildAvatar(Colors.grey.shade400)),
                        Transform.translate(offset: const Offset(-16, 0), child: _buildAvatar(Colors.grey.shade500)),
                        Transform.translate(
                          offset: const Offset(-24, 0),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primary,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              count,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Joining room: $title...'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'JOIN ROOM',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildDailyDevotion(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                Expanded(
                  child: _buildDailyDevotionText(context),
                ),
                const SizedBox(width: 48),
                Expanded(
                  child: _buildDailyDevotionImage(context),
                ),
              ],
            );
          }
          return Column(
            children: [
              _buildDailyDevotionImage(context),
              const SizedBox(height: 48),
              _buildDailyDevotionText(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDailyDevotionText(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AFTERNOON DEVOTION',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'The Silence of the Soul',
          style: theme.textTheme.displayMedium?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'In the quietude of your heart, the Word finds a fertile soil. Today, we reflect on the power of stillness in an age of constant noise.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Text(
            'READ MEDITATION',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyDevotionImage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipOval(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCLLJkEKLFR1dlMvaHIm9MohC_jmKY6KgD2YJDQwsqZS2Simfb9vRRRXw1ca-n7isggJ6rxaVpha8UJGbIlzvf02GPy77IG59nnS93U-YH-shB2JBkqEV0oKqaz0BF8vzRUWAlyrET8BB4aOI5yVwuipO3-66HRhOynJMYXd8MXDL6iuW0yy07WWjdo9ae2E06eExCAfj883H84o1k0_BLA98SYSTWHeH12XaZ5y3yZ4RUpaRag_HsiX0Cnd02w562KKzBLiaxQfKQ',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -24,
          left: -24,
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, color: Colors.white, size: 32),
                const SizedBox(height: 12),
                Text(
                  '"Be still, and know that I am God."',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
