import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firebase_auth_service.dart';

/// ========================================================================
/// Auth Provider (ChangeNotifier)
/// ========================================================================
/// Manages authentication state and provides methods for:
/// - Email/Password sign-in and sign-up
/// - Google Sign-In
/// - Apple Sign-In
/// - Guest (anonymous) sign-in
/// - Sign out
/// - Password reset
///
/// Wraps [FirebaseAuthService] and exposes [User] state via ChangeNotifier.
/// ========================================================================

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  User? _user;
  bool _isGuest = false;
  bool _isLoading = false;
  String? _errorMessage;

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  /// The currently signed-in Firebase user, or null.
  User? get user => _user;

  /// Whether the user is signed in (authenticated or anonymous).
  bool get isSignedIn => _user != null || _isGuest;

  /// Whether the current session is a guest (anonymous) session.
  bool get isGuest => _isGuest;

  /// Whether an operation is in progress.
  bool get isLoading => _isLoading;

  /// The last error message, if any.
  String? get errorMessage => _errorMessage;

  /// The user's display name, or a fallback.
  String get displayName =>
      _user?.displayName ??
      _user?.email?.split('@').first ??
      (_isGuest ? 'Guest' : 'Reader');

  /// The user's email, or null.
  String? get email => _user?.email;

  /// The user's photo URL, or null.
  String? get photoUrl => _user?.photoURL;

  // ---------------------------------------------------------------------------
  // Constructor – listen to auth state changes
  // ---------------------------------------------------------------------------

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
    // Set initial state from current user
    _user = _authService.currentUser;
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    if (user != null) {
      _isGuest = user.isAnonymous;
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Email / Password Sign-In
  // ---------------------------------------------------------------------------

  /// Signs in with email and password via Firebase.
  ///
  /// Returns `true` on success, `false` on failure (check [errorMessage]).
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.signInWithEmail(email: email, password: password);
      _isGuest = false;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Email / Password Sign-Up
  // ---------------------------------------------------------------------------

  /// Creates a new user account with email and password.
  ///
  /// Returns `true` on success, `false` on failure (check [errorMessage]).
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.signUpWithEmail(email: email, password: password);
      _isGuest = false;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  /// Initiates Google Sign-In flow.
  ///
  /// Returns `true` on success, `false` on failure or user cancellation.
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);
    try {
      final result = await _authService.signInWithGoogle();
      if (result == null) {
        // User cancelled the flow
        _setLoading(false);
        return false;
      }
      _isGuest = false;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Google sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Apple Sign-In
  // ---------------------------------------------------------------------------

  /// Initiates Apple Sign-In flow (iOS/macOS only).
  ///
  /// Returns `true` on success, `false` on failure or user cancellation.
  Future<bool> signInWithApple() async {
    _setLoading(true);
    _setError(null);
    try {
      final result = await _authService.signInWithApple();
      if (result == null) {
        _setLoading(false);
        return false;
      }
      _isGuest = false;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      _setLoading(false);
      return false;
    } on UnsupportedError {
      _setError('Apple sign-in is not supported on this platform.');
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Apple sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Guest Sign-In
  // ---------------------------------------------------------------------------

  /// Signs in anonymously (guest mode).
  ///
  /// Returns `true` on success.
  Future<bool> signInAsGuest() async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.signInAnonymously();
      _isGuest = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Guest sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Password Reset
  // ---------------------------------------------------------------------------

  /// Sends a password reset email to the given address.
  ///
  /// Returns `true` on success.
  Future<bool> sendPasswordReset({required String email}) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to send reset email. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Legacy compatibility methods (used by existing UI)
  // ---------------------------------------------------------------------------

  /// Legacy method – use [signInAsGuest] instead.
  void loginAsGuest() {
    _isGuest = true;
    notifyListeners();
  }

  /// Legacy method – marks user as authenticated.
  void loginAsUser() {
    _isGuest = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Sign Out
  // ---------------------------------------------------------------------------

  /// Signs out from Firebase and clears local state.
  Future<void> logout() async {
    await _authService.signOut();
    _isGuest = false;
    _user = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Error Mapping
  // ---------------------------------------------------------------------------

  /// Maps Firebase error codes to user-friendly messages.
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
