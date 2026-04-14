import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../nav.dart';
import '../widgets/language_selection_sheet.dart';
import '../widgets/theme_selection_sheet.dart';
import '../theme_provider.dart';
import '../settings_provider.dart';
import 'translation_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppLanguage _currentLanguage = allWorldLanguages.firstWhere((l) => l.code == 'en');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle(context, 'PREFERENCES'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Theme',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ThemeCardSelector(
                        currentMode: context.watch<ThemeProvider>().themeMode,
                        onModeChanged: (ThemeMode newSelection) {
                          context.read<ThemeProvider>().setThemeMode(newSelection);
                        },
                      ),
                    ],
                  ),
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.text_fields_rounded,
                  title: 'Typography & Layout',
                  subtitle: 'Font size, spacing, and justification',
                  onTap: () {},
                ),
                Consumer<SettingsProvider>(
                  builder: (context, settings, _) {
                    final currentTranslation = bibleTranslations.firstWhere(
                      (t) => t.id == settings.currentTranslationId,
                      orElse: () => bibleTranslations.first,
                    );
                    return _buildSettingsItem(
                      context,
                      icon: Icons.language_rounded,
                      title: 'Translation',
                      subtitle: '${currentTranslation.name} (${currentTranslation.abbreviation})',
                      onTap: () {
                        context.push(AppRoutes.translation);
                      },
                    );
                  },
                ),
                _buildDivider(context),
                
                _buildSectionTitle(context, 'LANGUAGE'),
                _buildSettingsItem(
                  context,
                  icon: Icons.g_translate_rounded,
                  title: 'App Language',
                  subtitle: '${_currentLanguage.name} (${_currentLanguage.nativeName})',
                  onTap: () async {
                    final selectedLang = await LanguageSelectionSheet.show(
                      context,
                      currentLanguage: _currentLanguage,
                    );
                    if (selectedLang != null) {
                      setState(() {
                        _currentLanguage = selectedLang;
                      });
                    }
                  },
                ),
                _buildDivider(context),
                
                _buildSectionTitle(context, 'NOTIFICATIONS'),
                _buildSettingsItem(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: 'Daily Reminders',
                  subtitle: '9:00 AM • Morning Devotional',
                  onTap: () {},
                  trailing: _buildSwitch(context, true),
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.event_note_rounded,
                  title: 'Reading Plans',
                  subtitle: 'Updates on your 1-year reading journey',
                  onTap: () {},
                  trailing: _buildSwitch(context, true),
                ),
                _buildDivider(context),
                
                _buildSectionTitle(context, 'ABOUT & LEGAL'),
                _buildSettingsItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: '1.0.4 (Build 42)',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    context.push(AppRoutes.privacyPolicy);
                  },
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.gavel_rounded,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    context.push(AppRoutes.helpSupport);
                  },
                ),
                _buildDivider(context),
                
                _buildSectionTitle(context, 'ACCOUNT'),
                _buildSettingsItem(
                  context,
                  icon: Icons.cloud_sync_outlined,
                  title: 'Sync Status',
                  subtitle: 'Last synced: 2 mins ago',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.person_off_rounded,
                  title: 'Delete Account',
                  textColor: colorScheme.error,
                  iconColor: colorScheme.error,
                  onTap: () {},
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        height: 1,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildSwitch(BuildContext context, bool value) {
    return Switch(
      value: value,
      onChanged: (val) {},
      activeColor: Theme.of(context).colorScheme.surface,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      inactiveThumbColor: Theme.of(context).colorScheme.onSurfaceVariant,
      inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
               Icon(
                 icon,
                 color: iconColor ?? colorScheme.onSurfaceVariant,
                 size: 24,
               ),
               const SizedBox(width: 24),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       title,
                       style: theme.textTheme.titleMedium?.copyWith(
                         color: textColor ?? colorScheme.onSurface,
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                     if (subtitle != null) ...[
                       const SizedBox(height: 4),
                       Text(
                         subtitle,
                         style: theme.textTheme.bodySmall?.copyWith(
                           color: colorScheme.onSurfaceVariant,
                           height: 1.2,
                         ),
                       ),
                     ],
                   ],
                 ),
               ),
               if (trailing != null)
                 trailing
               else
                 Icon(
                   Icons.chevron_right_rounded,
                   color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                   size: 20,
                 ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeCardSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onModeChanged;

  const _ThemeCardSelector({
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThemeCard(
            mode: ThemeMode.system,
            currentMode: currentMode,
            title: 'System',
            icon: Icons.brightness_auto_rounded,
            onTap: () => onModeChanged(ThemeMode.system),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeCard(
            mode: ThemeMode.light,
            currentMode: currentMode,
            title: 'Light',
            icon: Icons.light_mode_rounded,
            onTap: () => onModeChanged(ThemeMode.light),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeCard(
            mode: ThemeMode.dark,
            currentMode: currentMode,
            title: 'Dark',
            icon: Icons.dark_mode_rounded,
            onTap: () => onModeChanged(ThemeMode.dark),
          ),
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final ThemeMode mode;
  final ThemeMode currentMode;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.mode,
    required this.currentMode,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = mode == currentMode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? colorScheme.primaryContainer.withValues(alpha: 0.15)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            _buildPreview(context, mode, isSelected),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, ThemeMode mode, bool isSelected) {
    final theme = Theme.of(context);
    
    const lightBg = Color(0xFFFBF9F4);
    const lightAppBar = Color(0xFFE4E2DD);
    const lightLine1 = Color(0xFFD0CEC9);
    const lightLine2 = Color(0xFFE4E2DD);

    const darkBg = Color(0xFF1B1C19);
    const darkAppBar = Color(0xFF323232);
    const darkLine1 = Color(0xFF4A4A4A);
    const darkLine2 = Color(0xFF323232);

    if (mode == ThemeMode.system) {
      return Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary.withValues(alpha: 0.5) 
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: lightBg,
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, decoration: BoxDecoration(color: lightAppBar, borderRadius: BorderRadius.circular(4))),
                      const Spacer(),
                      Container(height: 6, width: 24, decoration: BoxDecoration(color: lightLine1, borderRadius: BorderRadius.circular(3))),
                      const SizedBox(height: 6),
                      Container(height: 6, width: 14, decoration: BoxDecoration(color: lightLine2, borderRadius: BorderRadius.circular(3))),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: darkBg,
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, decoration: BoxDecoration(color: darkAppBar, borderRadius: BorderRadius.circular(4))),
                      const Spacer(),
                      Container(height: 6, width: 24, decoration: BoxDecoration(color: darkLine1, borderRadius: BorderRadius.circular(3))),
                      const SizedBox(height: 6),
                      Container(height: 6, width: 14, decoration: BoxDecoration(color: darkLine2, borderRadius: BorderRadius.circular(3))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isLight = mode == ThemeMode.light;
    final bgColor = isLight ? lightBg : darkBg;
    final appBarColor = isLight ? lightAppBar : darkAppBar;
    final line1Color = isLight ? lightLine1 : darkLine1;
    final line2Color = isLight ? lightLine2 : darkLine2;

    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected 
              ? theme.colorScheme.primary.withValues(alpha: 0.5) 
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: appBarColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Spacer(),
          Container(
            height: 6,
            width: 40,
            decoration: BoxDecoration(
              color: line1Color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            width: 24,
            decoration: BoxDecoration(
              color: line2Color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

