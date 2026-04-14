import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleTranslation {
  final String id;
  final String name;
  final String abbreviation;
  final String language;
  final String description;
  final bool isDownloaded;
  final String category;

  const BibleTranslation({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.language,
    required this.description,
    required this.category,
    this.isDownloaded = false,
  });
}

const List<BibleTranslation> bibleTranslations = [
  BibleTranslation(
    id: 'kjv',
    name: 'King James Version',
    abbreviation: 'KJV',
    language: 'English',
    description: 'The historic and poetic English translation from 1611.',
    category: 'Classic',
    isDownloaded: false,
  ),
  BibleTranslation(
    id: 'web',
    name: 'World English Bible',
    abbreviation: 'WEB',
    language: 'English',
    description: 'A modern English translation of the Holy Bible based on the ASV.',
    category: 'Modern',
    isDownloaded: false,
  ),
  BibleTranslation(
    id: 'bbe',
    name: 'Bible in Basic English',
    abbreviation: 'BBE',
    language: 'English',
    description: 'A translation using a simplified vocabulary.',
    category: 'Study',
    isDownloaded: false,
  ),
  BibleTranslation(
    id: 'oeb-us',
    name: 'Open English Bible (US)',
    abbreviation: 'OEB-US',
    language: 'English',
    description: 'A modern English translation completely in the public domain.',
    category: 'Modern',
    isDownloaded: false,
  ),
  BibleTranslation(
    id: 'almeida',
    name: 'João Ferreira de Almeida',
    abbreviation: 'JFA',
    language: 'Português',
    description: 'A traditional Portuguese translation of the Bible.',
    category: 'International',
    isDownloaded: false,
  ),
  BibleTranslation(
    id: 'clementine',
    name: 'Clementine Vulgate',
    abbreviation: 'VULG',
    language: 'Latin',
    description: 'The official Latin edition of the Bible published in 1592.',
    category: 'Classic',
    isDownloaded: false,
  ),
];

class SettingsProvider extends ChangeNotifier {
  String _currentTranslationId = 'kjv';

  String get currentTranslationId => _currentTranslationId;
  String get currentTranslationAbbreviation {
    return bibleTranslations
        .firstWhere((t) => t.id == _currentTranslationId, orElse: () => bibleTranslations.first)
        .abbreviation;
  }
  
  String get currentTranslationName {
    return bibleTranslations
        .firstWhere((t) => t.id == _currentTranslationId, orElse: () => bibleTranslations.first)
        .name;
  }

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? translationId = prefs.getString('translation_id');
      if (translationId != null) {
        _currentTranslationId = translationId;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load settings: $e');
    }
  }

  Future<void> setTranslationId(String id) async {
    if (_currentTranslationId == id) return;
    
    _currentTranslationId = id;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('translation_id', id);
    } catch (e) {
      debugPrint('Failed to save translation id: $e');
    }
  }
}
