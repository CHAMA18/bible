import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'translations.dart';

class AppLocalizations extends ChangeNotifier {
  String _currentLocale = 'en';

  String get currentLocale => _currentLocale;

  void setLocale(String locale) {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      notifyListeners();
    }
  }

  String translate(String text) {
    if (_currentLocale == 'en') return text;
    return translations[_currentLocale]?[text] ?? text;
  }

  static AppLocalizations of(BuildContext context) {
    return Provider.of<AppLocalizations>(context, listen: false);
  }
}

extension L10nExtension on BuildContext {
  String l10n(String text) {
    return watch<AppLocalizations>().translate(text);
  }
}
