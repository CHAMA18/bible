import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExploreCategoryPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String imageUrl;

  const ExploreCategoryPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.imageUrl,
  });

  List<Map<String, String>> _getContentForCategory() {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('people')) {
      return [
        {'title': 'Moses', 'subtitle': 'The Lawgiver and Prophet', 'icon': 'person'},
        {'title': 'David', 'subtitle': 'The Shepherd King', 'icon': 'person'},
        {'title': 'Elijah', 'subtitle': 'Prophet of Fire', 'icon': 'person'},
        {'title': 'Paul', 'subtitle': 'Apostle to the Gentiles', 'icon': 'person'},
        {'title': 'Mary', 'subtitle': 'Mother of Jesus', 'icon': 'person'},
        {'title': 'Abraham', 'subtitle': 'Father of Many Nations', 'icon': 'person'},
      ];
    } else if (lowerTitle.contains('miracle')) {
      return [
        {'title': 'Feeding the 5000', 'subtitle': 'Multiplying loaves and fishes', 'icon': 'auto_awesome'},
        {'title': 'Parting the Red Sea', 'subtitle': 'Escape from Egypt', 'icon': 'water'},
        {'title': 'Water into Wine', 'subtitle': 'The first miracle at Cana', 'icon': 'local_drink'},
        {'title': 'Walking on Water', 'subtitle': 'Faith amidst the storm', 'icon': 'waves'},
        {'title': 'Raising Lazarus', 'subtitle': 'Power over death', 'icon': 'accessibility_new'},
      ];
    } else if (lowerTitle.contains('parable')) {
      return [
        {'title': 'The Good Samaritan', 'subtitle': 'Loving your neighbor', 'icon': 'favorite'},
        {'title': 'The Prodigal Son', 'subtitle': 'Forgiveness and redemption', 'icon': 'home'},
        {'title': 'The Sower', 'subtitle': 'Hearing the word of God', 'icon': 'eco'},
        {'title': 'The Mustard Seed', 'subtitle': 'Faith that grows', 'icon': 'grass'},
        {'title': 'The Lost Sheep', 'subtitle': 'Rejoicing over the found', 'icon': 'pets'},
      ];
    } else if (lowerTitle.contains('geography') || lowerTitle.contains('journey')) {
      return [
        {'title': 'Jerusalem', 'subtitle': 'The Holy City', 'icon': 'location_city'},
        {'title': 'Sea of Galilee', 'subtitle': 'Where Jesus taught and walked', 'icon': 'sailing'},
        {'title': 'Mount Sinai', 'subtitle': 'Where Moses received the Law', 'icon': 'terrain'},
        {'title': 'Bethlehem', 'subtitle': 'The birthplace of Jesus', 'icon': 'star'},
        {'title': 'Nazareth', 'subtitle': 'Jesus\' childhood home', 'icon': 'house'},
      ];
    }
    
    // Default fallback
    return [
      {'title': 'Overview', 'subtitle': 'Introduction to $title', 'icon': 'info'},
      {'title': 'Key Highlights', 'subtitle': 'Important points', 'icon': 'star'},
      {'title': 'Historical Context', 'subtitle': 'Background information', 'icon': 'history'},
      {'title': 'Theological Impact', 'subtitle': 'Significance today', 'icon': 'menu_book'},
    ];
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person': return Icons.person;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'water': return Icons.water;
      case 'local_drink': return Icons.local_drink;
      case 'waves': return Icons.waves;
      case 'accessibility_new': return Icons.accessibility_new;
      case 'favorite': return Icons.favorite;
      case 'home': return Icons.home;
      case 'eco': return Icons.eco;
      case 'grass': return Icons.grass;
      case 'pets': return Icons.pets;
      case 'location_city': return Icons.location_city;
      case 'sailing': return Icons.sailing;
      case 'terrain': return Icons.terrain;
      case 'star': return Icons.star;
      case 'house': return Icons.house;
      case 'history': return Icons.history;
      case 'menu_book': return Icons.menu_book;
      default: return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final items = _getContentForCategory();
    
    // Clean up title format (e.g., removing newlines)
    final displayTitle = title.replaceAll('\n', ' ');

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                displayTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  if (subtitle != null)
                    Positioned(
                      top: 120,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          subtitle!.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            letterSpacing: 3.0,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: Text(
                'Browse Collection',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // Show a quick simple modal or just navigate for feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening ${item['title']}...'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getIconData(item['icon']!),
                                    color: colorScheme.primary,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title']!,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['subtitle']!,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
