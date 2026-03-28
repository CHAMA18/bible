import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../nav.dart';
import '../auth_provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Holy Bible',
                    style: textTheme.headlineSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sacred texts for the modern soul',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'LIBRARY',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.bookmark_rounded,
                    label: 'Bookmarks',
                    route: null,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.edit_note_rounded,
                    label: 'Highlights & Notes',
                    route: null,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.history_rounded,
                    label: 'Reading History',
                    route: null,
                  ),
                ],
              ),
            ),
            
            // Account Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'ACCOUNT',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.logout_rounded,
                    label: 'Log Out',
                    onTap: () {
                      Navigator.pop(context);
                      context.read<AuthProvider>().logout();
                      context.go(AppRoutes.auth);
                    },
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.person_off_rounded,
                    label: 'Delete Account',
                    iconColor: colorScheme.error,
                    textColor: colorScheme.error,
                    onTap: () {
                      Navigator.pop(context);
                      // Add delete account logic here later
                    },
                  ),
                ],
              ),
            ),
            
            // Footer
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.settings);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.settings_rounded, color: colorScheme.onSurfaceVariant, size: 20),
                      const SizedBox(width: 16),
                      Text(
                        'Settings',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'v1.0.0',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? route,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = route != null && currentRoute == route;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.pop(context); // Close drawer
          if (route != null && !isSelected) {
            context.go(route);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.secondaryContainer.withValues(alpha: 0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? (isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant),
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor ?? (isSelected ? colorScheme.primary : colorScheme.onSurface),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
