import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette (cream, coral, sage) applied across light / dark Material 3.
abstract final class AppColors {
  static const cream = Color(0xFFF9F6F0);
  static const coral = Color(0xFFE07A5F);
  static const sage = Color(0xFF81B29A);
}

class AppTheme {
  static ThemeData light() {
    final scheme = _lightColorScheme();
    return _build(scheme, isDark: false);
  }

  static ThemeData dark() {
    final scheme = _darkColorScheme();
    return _build(scheme, isDark: true);
  }

  static ColorScheme _lightColorScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      brightness: Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    );
    return base.copyWith(
      primary: AppColors.coral,
      onPrimary: const Color(0xFFFFFFFF),
      primaryContainer: const Color(0xFFFADCD4),
      onPrimaryContainer: const Color(0xFF5C2418),
      secondary: AppColors.sage,
      onSecondary: const Color(0xFFFFFFFF),
      secondaryContainer: const Color(0xFFD2E8DF),
      onSecondaryContainer: const Color(0xFF153528),
      tertiary: AppColors.sage,
      onTertiary: const Color(0xFFFFFFFF),
      tertiaryContainer: const Color(0xFFC5DDD2),
      onTertiaryContainer: const Color(0xFF153528),
      surface: AppColors.cream,
      onSurface: const Color(0xFF2A2724),
      surfaceContainerLowest: const Color(0xFFF7F4ED),
      surfaceContainerLow: const Color(0xFFF5F2EA),
      surfaceContainer: const Color(0xFFF1EEE6),
      surfaceContainerHigh: const Color(0xFFEBE7DD),
      surfaceContainerHighest: const Color(0xFFE3DFD3),
      onSurfaceVariant: const Color(0xFF5D574E),
      outline: const Color(0xFFC5BFB4),
      outlineVariant: const Color(0xFFD9D4CA),
      surfaceTint: AppColors.coral,
      inverseSurface: const Color(0xFF2E2B27),
      onInverseSurface: AppColors.cream,
      inversePrimary: const Color(0xFFFFB4A0),
    );
  }

  static ColorScheme _darkColorScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    );
    return base.copyWith(
      primary: AppColors.coral,
      onPrimary: const Color(0xFFFFFFFF),
      primaryContainer: const Color(0xFF8B3D2E),
      onPrimaryContainer: const Color(0xFFFFDAD4),
      secondary: AppColors.sage,
      onSecondary: const Color(0xFFFFFFFF),
      secondaryContainer: const Color(0xFF3D5E52),
      onSecondaryContainer: const Color(0xFFD2E8DF),
      tertiary: AppColors.sage,
      onTertiary: const Color(0xFFFFFFFF),
      tertiaryContainer: const Color(0xFF355349),
      onTertiaryContainer: const Color(0xFFC5DDD2),
      surface: const Color(0xFF121816),
      onSurface: const Color(0xFFE8E4DC),
      surfaceContainerLowest: const Color(0xFF0D0F0E),
      surfaceContainerLow: const Color(0xFF151917),
      surfaceContainer: const Color(0xFF1B1F1D),
      surfaceContainerHigh: const Color(0xFF252A27),
      surfaceContainerHighest: const Color(0xFF303633),
      onSurfaceVariant: const Color(0xFFBFC4BE),
      outline: const Color(0xFF6D726D),
      outlineVariant: const Color(0xFF454945),
      surfaceTint: AppColors.coral,
      inverseSurface: AppColors.cream,
      onInverseSurface: const Color(0xFF2A2724),
      inversePrimary: const Color(0xFFB84A32),
    );
  }

  static ThemeData _build(ColorScheme scheme, {required bool isDark}) {
    final splash = scheme.primary.withValues(alpha: isDark ? 0.14 : 0.10);
    final scaffoldBg = scheme.surface;
    final textTheme = _poppinsTextTheme(scheme, isDark: isDark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: scaffoldBg,
      splashColor: splash,
      highlightColor: splash,
      hoverColor: scheme.onSurface.withValues(alpha: 0.06),
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: scheme.surfaceTint.withValues(alpha: isDark ? 0.28 : 0.22),
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        surfaceTintColor: scheme.primary.withValues(alpha: isDark ? 0.10 : 0.06),
        shadowColor: scheme.shadow.withValues(alpha: isDark ? 0.45 : 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.secondary,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.onSecondary,
        elevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.secondary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint.withValues(alpha: 0.2),
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 72,
        elevation: 2,
        shadowColor: scheme.shadow.withValues(alpha: isDark ? 0.5 : 0.08),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.onSecondaryContainer, size: 24);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: scheme.surfaceTint.withValues(alpha: 0.15),
        modalBackgroundColor: scheme.surfaceContainerHigh,
        showDragHandle: true,
        dragHandleColor: scheme.onSurfaceVariant.withValues(alpha: 0.35),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: scheme.surfaceTint.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        shadowColor: scheme.shadow.withValues(alpha: 0.2),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: GoogleFonts.poppins(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.secondary.withValues(alpha: 0.35),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.55),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textTheme: textTheme,
    );
  }

  static TextTheme _poppinsTextTheme(ColorScheme scheme, {required bool isDark}) {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final material = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
    ).textTheme;
    final base = GoogleFonts.poppinsTextTheme(material);
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: scheme.onSurface,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.35,
        color: scheme.onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: scheme.onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        height: 1.35,
        color: scheme.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        height: 1.35,
        color: scheme.onSurface,
      ),
      bodySmall: base.bodySmall?.copyWith(
        height: 1.3,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
