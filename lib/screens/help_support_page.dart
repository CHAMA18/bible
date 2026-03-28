import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I change the app theme?',
      'answer': 'You can change the app theme by going to Settings and selecting your preferred mode (Light, Dark, or System) under the Preferences section.',
    },
    {
      'question': 'Can I read offline?',
      'answer': 'Yes! Once a book is downloaded to your library, it is available for offline reading without an internet connection.',
    },
    {
      'question': 'How do I sync my reading progress?',
      'answer': 'Your reading progress is automatically synced when you are connected to the internet and logged into your account.',
    },
    {
      'question': 'Where can I find my highlights?',
      'answer': 'Your highlights and notes can be found in the Profile section under the "My Notes" tab.',
    },
  ];

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
          'Help & Support',
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
                _buildSearchField(context),
                const SizedBox(height: 32),
                _buildQuickActions(context),
                const SizedBox(height: 32),
                Text(
                  'Frequently Asked Questions',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFAQSection(context),
                const SizedBox(height: 48),
                _buildContactSupport(context),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: 'How can we help you?',
        prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionCard(
          context,
          icon: Icons.article_rounded,
          label: 'Guides',
          color: Colors.blue,
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.receipt_long_rounded,
          label: 'Billing',
          color: Colors.green,
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.bug_report_rounded,
          label: 'Report Issue',
          color: Colors.orange,
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.chat_rounded,
          label: 'Live Chat',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required MaterialColor color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? color.shade900.withValues(alpha: 0.3) : color.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? color.shade700.withValues(alpha: 0.5) : color.shade200,
            ),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: isDark ? color.shade300 : color.shade700,
              size: 28,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _faqs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final faq = _faqs[index];
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                faq['question']!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              children: [
                Text(
                  faq['answer']!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.headset_mic_rounded,
            size: 48,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 16),
          Text(
            'Still need help?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our support team is available 24/7 to assist you.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.email_rounded, color: theme.colorScheme.onPrimary),
            label: Text(
              'Contact Support',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
