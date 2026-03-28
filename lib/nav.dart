import 'package:bible_app/main.dart';
import 'package:bible_app/screens/reader_page.dart';
import 'package:bible_app/screens/profile_page.dart';
import 'package:bible_app/screens/search_page.dart';
import 'package:bible_app/screens/library_page.dart';
import 'package:bible_app/screens/settings_page.dart';
import 'package:bible_app/screens/auth_page.dart';
import 'package:bible_app/screens/signup_page.dart';
import 'package:bible_app/screens/privacy_policy_page.dart';
import 'package:bible_app/screens/help_support_page.dart';
import 'package:bible_app/screens/translation_page.dart';
import 'package:bible_app/screens/explore_category_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.auth,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AuthPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignupPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ReaderPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SearchPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.library,
        name: 'library',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LibraryPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        name: 'privacyPolicy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: AppRoutes.helpSupport,
        name: 'helpSupport',
        builder: (context, state) => const HelpSupportPage(),
      ),
      GoRoute(
        path: AppRoutes.translation,
        name: 'translation',
        builder: (context, state) => const TranslationPage(),
      ),
      GoRoute(
        path: AppRoutes.exploreCategory,
        name: 'exploreCategory',
        builder: (context, state) {
          final Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
          return ExploreCategoryPage(
            title: extra['title'] as String? ?? 'Explore',
            subtitle: extra['subtitle'] as String?,
            imageUrl: extra['imageUrl'] as String? ?? '',
          );
        },
      ),
    ],
  );
}

class AppRoutes {
  static const String auth = '/auth';
  static const String signup = '/signup';
  static const String home = '/';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String library = '/library';
  static const String settings = '/settings';
  static const String privacyPolicy = '/privacy-policy';
  static const String helpSupport = '/help-support';
  static const String translation = '/translation';
  static const String exploreCategory = '/explore-category';
}
