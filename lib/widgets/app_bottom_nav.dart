import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../nav.dart';
import '../auth_provider.dart';
import 'global_ad_banner.dart';

class AppBottomNav extends StatelessWidget {
  final String currentRoute;

  const AppBottomNav({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final navContainer = Container(
      height: 96,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF58413F).withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: Icons.explore,
              label: 'Discover',
              isActive: currentRoute == AppRoutes.home,
              onTap: () {
                if (currentRoute != AppRoutes.home) {
                  context.go(AppRoutes.home);
                }
              },
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: Icons.menu_book,
              label: 'Bible',
              isActive: false,
              onTap: () {},
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: Icons.library_books,
              label: 'Library',
              isActive: currentRoute == AppRoutes.library,
              onTap: () {
                if (currentRoute != AppRoutes.library) {
                  context.go(AppRoutes.library);
                }
              },
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: Icons.search,
              label: 'Search',
              isActive: currentRoute == AppRoutes.search,
              onTap: () {
                if (currentRoute != AppRoutes.search) {
                  context.go(AppRoutes.search);
                }
              },
            ),
          ),
          if (!context.watch<AuthProvider>().isGuest)
            Expanded(
              child: _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: currentRoute == AppRoutes.profile,
                onTap: () {
                  if (currentRoute != AppRoutes.profile) {
                    context.go(AppRoutes.profile);
                  }
                },
              ),
            ),
        ],
      ),
    );
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GlobalAdBanner(),
        navContainer,
      ],
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    if (isActive) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 10,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Opacity(
          opacity: 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
