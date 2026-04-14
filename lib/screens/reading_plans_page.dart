import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bible_app/nav.dart';

class ReadingPlan {
  final String id;
  final String title;
  final String subtitle;
  final int durationDays;
  final IconData icon;
  final List<Color> gradientColors;

  ReadingPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.durationDays,
    required this.icon,
    required this.gradientColors,
  });
}

class ReadingPlansPage extends StatefulWidget {
  const ReadingPlansPage({super.key});

  @override
  State<ReadingPlansPage> createState() => _ReadingPlansPageState();
}

class _ReadingPlansPageState extends State<ReadingPlansPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Old Testament', 'New Testament', 'Topical', 'Devotional'];

  final List<ReadingPlan> _plans = [
    ReadingPlan(
      id: '1',
      title: 'The Wisdom of Proverbs',
      subtitle: 'Deep dive into ancient wisdom',
      durationDays: 30,
      icon: Icons.menu_book_rounded,
      gradientColors: [const Color(0xFF8C1D1D), const Color(0xFFD32F2F)],
    ),
    ReadingPlan(
      id: '2',
      title: 'Bible in a Year',
      subtitle: 'Read the entire Bible in 365 days',
      durationDays: 365,
      icon: Icons.calendar_month_rounded,
      gradientColors: [const Color(0xFF715C27), const Color(0xFFB5933C)],
    ),
    ReadingPlan(
      id: '3',
      title: 'Gospels in 30 Days',
      subtitle: 'The life and teachings of Jesus',
      durationDays: 30,
      icon: Icons.auto_awesome_rounded,
      gradientColors: [const Color(0xFF2E7D32), const Color(0xFF4CAF50)],
    ),
    ReadingPlan(
      id: '4',
      title: 'Psalms of Comfort',
      subtitle: 'Finding peace in difficult times',
      durationDays: 14,
      icon: Icons.favorite_rounded,
      gradientColors: [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
    ),
    ReadingPlan(
      id: '5',
      title: 'Genesis Foundations',
      subtitle: 'The beginning of everything',
      durationDays: 21,
      icon: Icons.public_rounded,
      gradientColors: [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
    ),
    ReadingPlan(
      id: '6',
      title: 'Paul\'s Letters',
      subtitle: 'Theology and practical living',
      durationDays: 45,
      icon: Icons.mail_rounded,
      gradientColors: [const Color(0xFFE65100), const Color(0xFFFF9800)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, theme, colorScheme),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildCategories(theme, colorScheme),
                const SizedBox(height: 24),
                _buildFeaturedPlan(theme, colorScheme),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'More Plans',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildPlansGrid(context, theme, colorScheme),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        centerTitle: false,
        title: Text(
          'Reading Plans',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              left: 50,
              bottom: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.secondary.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              selectedColor: colorScheme.primary,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedPlan(ThemeData theme, ColorScheme colorScheme) {
    final plan = _plans.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Hero(
        tag: 'plan_bg_${plan.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: plan.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: plan.gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(AppRoutes.planDetails, extra: plan),
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'FEATURED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.bookmark_border_rounded, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Hero(
                      tag: 'plan_icon_${plan.id}',
                      child: Icon(plan.icon, size: 48, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(height: 16),
                    Hero(
                      tag: 'plan_title_${plan.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          plan.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Hero(
                      tag: 'plan_subtitle_${plan.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          plan.subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '${plan.durationDays} Days',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Start Plan',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: plan.gradientColors[0],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlansGrid(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    // Skip the first one as it's featured
    final gridPlans = _plans.skip(1).toList();
    
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final plan = gridPlans[index];
            return Hero(
              tag: 'plan_bg_${plan.id}',
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.planDetails, extra: plan),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'plan_icon_${plan.id}',
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: plan.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(plan.icon, color: Colors.white, size: 24),
                            ),
                          ),
                          const Spacer(),
                          Hero(
                            tag: 'plan_title_${plan.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                plan.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Hero(
                            tag: 'plan_subtitle_${plan.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                plan.subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${plan.durationDays} Days',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: gridPlans.length,
        ),
      ),
    );
  }
}
