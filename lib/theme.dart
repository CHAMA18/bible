import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  // Spacing values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Edge insets shortcuts
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

class LightModeColors {
  static const lightPrimary = Color(0xFF6B0109);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFF8C1D1D);
  static const lightOnPrimaryContainer = Color(0xFFFF9D95);

  static const lightSecondary = Color(0xFF715C27);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFFADD9B);
  static const lightOnSecondaryContainer = Color(0xFF75602B);

  static const lightTertiary = Color(0xFF323232);
  static const lightOnTertiary = Color(0xFFFFFFFF);

  static const lightError = Color(0xFFBA1A1A);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnErrorContainer = Color(0xFF93000A);

  static const lightSurface = Color(0xFFFBF9F4);
  static const lightOnSurface = Color(0xFF1B1C19);
  static const lightBackground = Color(0xFFFBF9F4);
  
  static const lightSurfaceContainerLow = Color(0xFFF5F3EE);
  static const lightSurfaceVariant = Color(0xFFE4E2DD);
  static const lightOnSurfaceVariant = Color(0xFF58413F);

  static const lightOutline = Color(0xFF8C716E);
  static const lightOutlineVariant = Color(0xFFDFBFBC);
  static const lightInversePrimary = Color(0xFFFFB3AD);
}

class DarkModeColors {
  static const darkPrimary = Color(0xFFFFB3AD);
  static const darkOnPrimary = Color(0xFF410003);
  static const darkPrimaryContainer = Color(0xFF8C1D1D);
  static const darkOnPrimaryContainer = Color(0xFFFFDAD6);

  static const darkSecondary = Color(0xFFFADD9B);
  static const darkOnSecondary = Color(0xFF251A00);
  static const darkSecondaryContainer = Color(0xFF715C27);
  static const darkOnSecondaryContainer = Color(0xFFFADD9B);

  static const darkTertiary = Color(0xFFC8C6C5);
  static const darkOnTertiary = Color(0xFF1B1C1C);

  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);

  static const darkSurface = Color(0xFF1B1C19);
  static const darkOnSurface = Color(0xFFFBF9F4);
  static const darkSurfaceContainerLow = Color(0xFF222321);
  static const darkSurfaceVariant = Color(0xFF58413F);
  static const darkOnSurfaceVariant = Color(0xFFDFBFBC);

  static const darkOutline = Color(0xFF8C716E);
  static const darkOutlineVariant = Color(0xFFDFBFBC);
  static const darkInversePrimary = Color(0xFF6B0109);
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 10.0;
  static const double bodyLarge = 18.0; // from text-lg
  static const double bodyMedium = 16.0;
  static const double bodySmall = 14.0;
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    secondaryContainer: LightModeColors.lightSecondaryContainer,
    onSecondaryContainer: LightModeColors.lightOnSecondaryContainer,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
    surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
    onSurfaceVariant: LightModeColors.lightOnSurfaceVariant,
    outline: LightModeColors.lightOutline,
    outlineVariant: LightModeColors.lightOutlineVariant,
    inversePrimary: LightModeColors.lightInversePrimary,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightModeColors.lightBackground,
  textTheme: _buildTextTheme(Brightness.light),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    secondaryContainer: DarkModeColors.darkSecondaryContainer,
    onSecondaryContainer: DarkModeColors.darkOnSecondaryContainer,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: DarkModeColors.darkError,
    onError: DarkModeColors.darkOnError,
    errorContainer: DarkModeColors.darkErrorContainer,
    onErrorContainer: DarkModeColors.darkOnErrorContainer,
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
    surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
    onSurfaceVariant: DarkModeColors.darkOnSurfaceVariant,
    outline: DarkModeColors.darkOutline,
    outlineVariant: DarkModeColors.darkOutlineVariant,
    inversePrimary: DarkModeColors.darkInversePrimary,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkModeColors.darkSurface,
  textTheme: _buildTextTheme(Brightness.dark),
);

TextTheme _buildTextTheme(Brightness brightness) {
  return TextTheme(
    displayLarge: GoogleFonts.newsreader(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.w300,
    ),
    displayMedium: GoogleFonts.newsreader(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.w300,
    ),
    displaySmall: GoogleFonts.newsreader(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w300,
    ),
    headlineLarge: GoogleFonts.newsreader(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.w300,
    ),
    headlineMedium: GoogleFonts.newsreader(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w300,
    ),
    headlineSmall: GoogleFonts.newsreader(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.w300,
    ),
    titleLarge: GoogleFonts.newsreader(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.newsreader(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.newsreader(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.manrope(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.manrope(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.manrope(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),
    bodyLarge: GoogleFonts.newsreader(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.w400,
      height: 1.8,
    ),
    bodyMedium: GoogleFonts.newsreader(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.w400,
      height: 1.8,
    ),
    bodySmall: GoogleFonts.newsreader(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.w400,
      height: 1.8,
    ),
  );
}
