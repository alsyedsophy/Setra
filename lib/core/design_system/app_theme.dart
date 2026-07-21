import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Application themes built from the design system tokens.
///
/// Both a light and a dark [ThemeData] are provided. Every component reads from
/// [Theme.of], so it adapts to the active theme automatically.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    final ColorScheme colorScheme;
    if (isLight) {
      colorScheme = ColorScheme(
        brightness: Brightness.light,
        primary: LightColors.primary,
        onPrimary: LightColors.onPrimary,
        primaryContainer: LightColors.primaryContainer,
        onPrimaryContainer: LightColors.onPrimaryContainer,
        secondary: LightColors.secondary,
        onSecondary: LightColors.onSecondary,
        secondaryContainer: LightColors.secondaryContainer,
        onSecondaryContainer: LightColors.onSecondaryContainer,
        tertiary: LightColors.tertiary,
        onTertiary: LightColors.onTertiary,
        tertiaryContainer: LightColors.tertiaryContainer,
        onTertiaryContainer: LightColors.onTertiaryContainer,
        error: LightColors.error,
        onError: LightColors.onError,
        errorContainer: LightColors.errorContainer,
        onErrorContainer: LightColors.onErrorContainer,
        surface: LightColors.surface,
        onSurface: LightColors.onSurface,
        surfaceContainerHighest: LightColors.surfaceVariant,
        onSurfaceVariant: LightColors.onSurfaceVariant,
        outline: LightColors.outline,
        outlineVariant: LightColors.outlineVariant,
      );
    } else {
      colorScheme = ColorScheme(
        brightness: Brightness.dark,
        primary: DarkColors.primary,
        onPrimary: DarkColors.onPrimary,
        primaryContainer: DarkColors.primaryContainer,
        onPrimaryContainer: DarkColors.onPrimaryContainer,
        secondary: DarkColors.secondary,
        onSecondary: DarkColors.onSecondary,
        secondaryContainer: DarkColors.secondaryContainer,
        onSecondaryContainer: DarkColors.onSecondaryContainer,
        tertiary: DarkColors.tertiary,
        onTertiary: DarkColors.onTertiary,
        tertiaryContainer: DarkColors.tertiaryContainer,
        onTertiaryContainer: DarkColors.onTertiaryContainer,
        error: DarkColors.error,
        onError: DarkColors.onError,
        errorContainer: DarkColors.errorContainer,
        onErrorContainer: DarkColors.onErrorContainer,
        surface: DarkColors.surface,
        onSurface: DarkColors.onSurface,
        surfaceContainerHighest: DarkColors.surfaceVariant,
        onSurfaceVariant: DarkColors.onSurfaceVariant,
        outline: DarkColors.outline,
        outlineVariant: DarkColors.outlineVariant,
      );
    }

    final TextTheme textTheme = isLight
        ? AppTextStyles.lightTextTheme
        : AppTextStyles.darkTextTheme;

    final OutlinedBorder buttonShape = RoundedRectangleBorder(
      borderRadius: AppRadius.mdRadius,
    );

    final EdgeInsetsGeometry buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.h_48,
      vertical: AppSpacing.w_24,
    );

    final EdgeInsetsGeometry inputPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.h_24,
      vertical: AppSpacing.w_4,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(textTheme.labelMedium),
          shape: WidgetStateProperty.all(buttonShape),
          padding: WidgetStateProperty.all(buttonPadding),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(textTheme.labelMedium),
          shape: WidgetStateProperty.all(buttonShape),
          padding: WidgetStateProperty.all(buttonPadding),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        elevation: 6,
      ),
    );
  }
}
