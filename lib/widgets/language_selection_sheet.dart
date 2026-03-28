import 'package:flutter/material.dart';

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

const List<AppLanguage> allWorldLanguages = [
  AppLanguage(code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦'),
  AppLanguage(code: 'sq', name: 'Albanian', nativeName: 'Shqip', flag: '🇦🇱'),
  AppLanguage(code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹'),
  AppLanguage(code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦'),
  AppLanguage(code: 'hy', name: 'Armenian', nativeName: 'Հայերեն', flag: '🇦🇲'),
  AppLanguage(code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan dili', flag: '🇦🇿'),
  AppLanguage(code: 'eu', name: 'Basque', nativeName: 'Euskara', flag: '🇪🇸'),
  AppLanguage(code: 'be', name: 'Belarusian', nativeName: 'Беларуская', flag: '🇧🇾'),
  AppLanguage(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩'),
  AppLanguage(code: 'bs', name: 'Bosnian', nativeName: 'Bosanski', flag: '🇧🇦'),
  AppLanguage(code: 'bg', name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬'),
  AppLanguage(code: 'ca', name: 'Catalan', nativeName: 'Català', flag: '🇪🇸'),
  AppLanguage(code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳'),
  AppLanguage(code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷'),
  AppLanguage(code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿'),
  AppLanguage(code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰'),
  AppLanguage(code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱'),
  AppLanguage(code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸'),
  AppLanguage(code: 'et', name: 'Estonian', nativeName: 'Eesti', flag: '🇪🇪'),
  AppLanguage(code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮'),
  AppLanguage(code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
  AppLanguage(code: 'gl', name: 'Galician', nativeName: 'Galego', flag: '🇪🇸'),
  AppLanguage(code: 'ka', name: 'Georgian', nativeName: 'ქართული', flag: '🇬🇪'),
  AppLanguage(code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪'),
  AppLanguage(code: 'el', name: 'Greek', nativeName: 'Ελληνικά', flag: '🇬🇷'),
  AppLanguage(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
  AppLanguage(code: 'ht', name: 'Haitian Creole', nativeName: 'Kreyòl Ayisyen', flag: '🇭🇹'),
  AppLanguage(code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱'),
  AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
  AppLanguage(code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺'),
  AppLanguage(code: 'is', name: 'Icelandic', nativeName: 'Íslenska', flag: '🇮🇸'),
  AppLanguage(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩'),
  AppLanguage(code: 'ga', name: 'Irish', nativeName: 'Gaeilge', flag: '🇮🇪'),
  AppLanguage(code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹'),
  AppLanguage(code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵'),
  AppLanguage(code: 'jv', name: 'Javanese', nativeName: 'Basa Jawa', flag: '🇮🇩'),
  AppLanguage(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳'),
  AppLanguage(code: 'kk', name: 'Kazakh', nativeName: 'Қазақ тілі', flag: '🇰🇿'),
  AppLanguage(code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷'),
  AppLanguage(code: 'ku', name: 'Kurdish', nativeName: 'Kurdî', flag: '🇮🇶'),
  AppLanguage(code: 'ky', name: 'Kyrgyz', nativeName: 'Кыргызча', flag: '🇰🇬'),
  AppLanguage(code: 'lo', name: 'Lao', nativeName: 'ລາວ', flag: '🇱🇦'),
  AppLanguage(code: 'la', name: 'Latin', nativeName: 'Latina', flag: '🇻🇦'),
  AppLanguage(code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻'),
  AppLanguage(code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių', flag: '🇱🇹'),
  AppLanguage(code: 'mk', name: 'Macedonian', nativeName: 'Македонски', flag: '🇲🇰'),
  AppLanguage(code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾'),
  AppLanguage(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳'),
  AppLanguage(code: 'mt', name: 'Maltese', nativeName: 'Malti', flag: '🇲🇹'),
  AppLanguage(code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳'),
  AppLanguage(code: 'mn', name: 'Mongolian', nativeName: 'Монгол', flag: '🇲🇳'),
  AppLanguage(code: 'ne', name: 'Nepali', nativeName: 'नेपाली', flag: '🇳🇵'),
  AppLanguage(code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴'),
  AppLanguage(code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷'),
  AppLanguage(code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱'),
  AppLanguage(code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹'),
  AppLanguage(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳'),
  AppLanguage(code: 'ro', name: 'Romanian', nativeName: 'Română', flag: '🇷🇴'),
  AppLanguage(code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺'),
  AppLanguage(code: 'sr', name: 'Serbian', nativeName: 'Српски', flag: '🇷🇸'),
  AppLanguage(code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰'),
  AppLanguage(code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮'),
  AppLanguage(code: 'so', name: 'Somali', nativeName: 'Soomaali', flag: '🇸🇴'),
  AppLanguage(code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸'),
  AppLanguage(code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪'),
  AppLanguage(code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪'),
  AppLanguage(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳'),
  AppLanguage(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳'),
  AppLanguage(code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭'),
  AppLanguage(code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷'),
  AppLanguage(code: 'uk', name: 'Ukrainian', nativeName: 'Українська', flag: '🇺🇦'),
  AppLanguage(code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰'),
  AppLanguage(code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbekcha', flag: '🇺🇿'),
  AppLanguage(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳'),
  AppLanguage(code: 'cy', name: 'Welsh', nativeName: 'Cymraeg', flag: '🇬🇧'),
  AppLanguage(code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa', flag: '🇿🇦'),
  AppLanguage(code: 'yi', name: 'Yiddish', nativeName: 'ייִדיש', flag: '🇮🇱'),
  AppLanguage(code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬'),
  AppLanguage(code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦'),
];

const List<String> popularLanguageCodes = [
  'en', 'es', 'zh', 'hi', 'ar', 'pt', 'fr', 'ru', 'ja', 'de'
];

class LanguageSelectionSheet extends StatefulWidget {
  final AppLanguage? currentLanguage;

  const LanguageSelectionSheet({
    super.key,
    this.currentLanguage,
  });

  static Future<AppLanguage?> show(BuildContext context, {AppLanguage? currentLanguage}) {
    return showModalBottomSheet<AppLanguage>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguageSelectionSheet(currentLanguage: currentLanguage),
    );
  }

  @override
  State<LanguageSelectionSheet> createState() => _LanguageSelectionSheetState();
}

class _LanguageSelectionSheetState extends State<LanguageSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<AppLanguage> _filteredLanguages = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredLanguages = allWorldLanguages;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredLanguages = allWorldLanguages;
      } else {
        _filteredLanguages = allWorldLanguages.where((lang) {
          return lang.name.toLowerCase().contains(_searchQuery) ||
              lang.nativeName.toLowerCase().contains(_searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isSearching = _searchQuery.isNotEmpty;
    
    // Group languages if not searching
    final popularLangs = _filteredLanguages.where((l) => popularLanguageCodes.contains(l.code)).toList();
    final otherLangs = _filteredLanguages.where((l) => !popularLanguageCodes.contains(l.code)).toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'App Language',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, color: colorScheme.onSurfaceVariant),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: TextField(
              controller: _searchController,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search languages...',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),

          // Divider
          Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),

          // List
          Expanded(
            child: _filteredLanguages.isEmpty
                ? _buildEmptyState(context)
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      if (!isSearching) ...[
                        if (popularLangs.isNotEmpty) ...[
                          _buildSectionHeader(context, 'SUGGESTED'),
                          ...popularLangs.map((lang) => _buildLanguageItem(context, lang)),
                          const SizedBox(height: 16),
                        ],
                        _buildSectionHeader(context, 'ALL LANGUAGES'),
                        ...otherLangs.map((lang) => _buildLanguageItem(context, lang)),
                      ] else ...[
                        _buildSectionHeader(context, 'SEARCH RESULTS'),
                        ..._filteredLanguages.map((lang) => _buildLanguageItem(context, lang)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, AppLanguage lang) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = widget.currentLanguage?.code == lang.code;

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(lang);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.3) : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                lang.flag,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lang.nativeName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No languages found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
