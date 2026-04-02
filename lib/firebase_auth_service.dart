import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// ========================================================================
/// Firebase Authentication Service
/// ========================================================================
/// Handles all Firebase Auth operations including:
/// - Email/Password sign-in and sign-up
/// - Google Sign-In
/// - Apple Sign-In (iOS/macOS)
/// - Anonymous (Guest) sign-in
/// - Password reset
/// ========================================================================

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ---------------------------------------------------------------------------
  // Current user
  // ---------------------------------------------------------------------------

  /// Returns the currently signed-in Firebase user, or null.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes (sign-in / sign-out).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isSignedIn => _auth.currentUser != null;

  // ---------------------------------------------------------------------------
  // Email / Password Authentication
  // ---------------------------------------------------------------------------

  /// Signs in with email and password.
  ///
  /// Returns a [UserCredential] on success.
  /// Throws a [FirebaseAuthException] on failure.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Creates a new user account with email and password.
  ///
  /// Returns a [UserCredential] on success.
  /// Throws a [FirebaseAuthException] on failure.
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sends a password reset email to the given address.
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  /// Initiates Google Sign-In flow and returns a [UserCredential].
  ///
  /// Returns null if the user cancels the flow.
  /// Throws on error.
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User cancelled
    }

    // Obtain auth details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the credential
    return await _auth.signInWithCredential(credential);
  }

  // ---------------------------------------------------------------------------
  // Apple Sign-In (iOS / macOS only)
  // ---------------------------------------------------------------------------

  /// Initiates Apple Sign-In flow and returns a [UserCredential].
  ///
  /// Returns null if the user cancels the flow.
  /// Only supported on iOS and macOS.
  Future<UserCredential?> signInWithApple() async {
    if (kIsWeb) {
      // Apple Sign-In is not supported on web in this implementation
      throw UnsupportedError('Apple Sign-In is not supported on web.');
    }

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Sign in to Firebase with the Apple credential.
    return await _auth.signInWithCredential(oauthCredential);
  }

  // ---------------------------------------------------------------------------
  // Anonymous (Guest) Sign-In
  // ---------------------------------------------------------------------------

  /// Signs in anonymously (guest mode).
  ///
  /// Returns a [UserCredential] for the anonymous user.
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // ---------------------------------------------------------------------------
  // Sign Out
  // ---------------------------------------------------------------------------

  /// Signs out from Firebase and Google Sign-In.
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Delete Account
  // ---------------------------------------------------------------------------

  /// Deletes the currently signed-in user's account.
  ///
  /// Requires recent authentication; may throw if re-authentication is needed.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
      await _googleSignIn.signOut();
    }
  }
}
