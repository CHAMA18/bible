import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isGuest = false;
  
  bool get isGuest => _isGuest;

  void loginAsGuest() {
    _isGuest = true;
    notifyListeners();
  }

  void loginAsUser() {
    _isGuest = false;
    notifyListeners();
  }
  
  void logout() {
    _isGuest = false;
    notifyListeners();
  }
}
