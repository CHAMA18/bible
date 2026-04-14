import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../nav.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isGuest = context.watch<AuthProvider>().isGuest;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: colorScheme.surface,
      drawer: isGuest ? null : const AppDrawer(currentRoute: AppRoutes.profile),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 100 + MediaQuery.of(context).padding.top,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                  isGuest ? const SizedBox(width: 48) : Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: colorScheme.primary),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Text(
                    'Profile',
                    style: textTheme.titleLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.logout, color: colorScheme.error),
                        onPressed: () {
                          context.read<AuthProvider>().logout();
                          context.go(AppRoutes.auth);
                        },
                        tooltip: 'Log Out',
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: colorScheme.primary),
                        onPressed: () {
                          context.push(AppRoutes.settings);
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
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 120 + MediaQuery.of(context).padding.top,
                bottom: 180,
                left: 24,
                right: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      _buildProfileSection(context),
                      const SizedBox(height: 48),
                      _buildInsightsBentoGrid(context),
                      const SizedBox(height: 24),
                      _buildPersonalLibrary(context),
                      const SizedBox(height: 24),
                      _buildRecentNote(context),
                      const SizedBox(height: 24),
                      _buildAccountManagement(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomNav(currentRoute: AppRoutes.profile),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surfaceContainerHighest, // equivalent to surface-container-low
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD_BFwJ_8-NOgl2xbxgVIjyjDxdCoNERHjENarrKtocslekQOeNCBO46eIXasZKtPw9lU_Ehqo55Xhkr16tn3EEPf1gqc2QJo0kQvtJR9LYfU3UFWMYQ-nUg6sZGNaDAgPL8ZGj5rRZQToJPHbIAvLk7yfmPqKS59I3VPeZhUaC3DyDBrR18XAGuaOyidNLJ_0LEjentOs9rZuRKvZUYMECJ-dzybpDKIRwVTphzpoaTUafAH81yaFm4rUk56X_Wcl098Fl-D4iM6s'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.verified,
                  color: theme.colorScheme.onSecondary,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Julian Thorne',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'MEMBER SINCE OCT 2021',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsBentoGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _buildReadingStreakCard(context)),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildProgressCard(context)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildReadingStreakCard(context),
              const SizedBox(height: 24),
              _buildProgressCard(context),
            ],
          );
        }
      },
    );
  }

  Widget _buildReadingStreakCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3), // equivalent to surface-container-low
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'READING STREAK',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '124',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Days',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDayPill(context, 'M', true),
                const SizedBox(width: 8),
                _buildDayPill(context, 'T', true),
                const SizedBox(width: 8),
                _buildDayPill(context, 'W', true),
                const SizedBox(width: 8),
                _buildDayPill(context, 'T', true),
                const SizedBox(width: 8),
                _buildDayPill(context, 'F', true),
                const SizedBox(width: 8),
                _buildDayPill(context, 'S', false),
                const SizedBox(width: 8),
                _buildDayPill(context, 'S', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayPill(BuildContext context, String day, bool active) {
    final theme = Theme.of(context);
    return Container(
      width: 40,
      height: 64,
      decoration: BoxDecoration(
        color: active
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: theme.textTheme.labelSmall?.copyWith(
          color: active ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1), // lowest
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF58413F).withValues(alpha: 0.05),
            blurRadius: 48,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'YEAR PROGRESS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 128,
            height: 128,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.6,
                  strokeWidth: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '60%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      'OF BIBLE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Next: Romans 8',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalLibrary(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: Text(
            'Your Sanctuary',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildLibraryItem(context, Icons.bookmark, 'Bookmarks', '42 Items'),
            _buildLibraryItem(context, Icons.edit_note, 'Notes', '128 Entries'),
            _buildLibraryItem(context, Icons.edit, 'Highlights', '215 Verses'),
            _buildLibraryItem(context, Icons.image, 'Images', '15 Saved'),
          ],
        ),
      ],
    );
  }

  Widget _buildLibraryItem(BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentNote(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: 0,
            child: Icon(
              Icons.format_quote,
              size: 64,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LATEST REFLECTION',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"Finding peace in Psalm 23 today. The imagery of \'still waters\' isn\'t just about silence, but about trust in the Shepherd\'s guidance."',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onBackground,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'ADDED 2 HOURS AGO',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'PSALM 23:2',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountManagement(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: Text(
            'Account Management',
            style: theme.textTheme.titleLarge?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildSettingsRow(context, Icons.notifications, 'Notifications & Reminders'),
        _buildSettingsRow(context, Icons.translate, 'Language & Translation Preferences'),
        _buildSettingsRow(context, Icons.cloud_sync, 'Backup & Synchronization'),
      ],
    );
  }

  Widget _buildSettingsRow(BuildContext context, IconData icon, String title) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}
