import "package:flutter/material.dart";
import "package:hexcolor/hexcolor.dart";

class MaterialTheme {
  final TextTheme textTheme;

  static Color redColor = HexColor("#EE3C66");
  static Color whiteColor = HexColor("#FBFBFB");
  static Color blackColor = HexColor("#151515");
  static Color dialogWarningColor = HexColor("#FBAE33");
  static Color dialogErrorColor = HexColor("#FF2F32");
  static Color dialogInfoColor = HexColor("#33FBEA");
  static Color greenColor = Color.fromARGB(255, 2, 92, 71);
  static Color otherColor = Color.fromARGB(255, 251, 0, 188);
  static Color otherColor2 = Color.fromARGB(255, 224, 146, 2);
  static Color subtitle = Color.fromARGB(255, 236, 236, 236);

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,

      // Tonos principales pastel
      primary: Color(0xFFFFB3BA), // rosa pastel
      onPrimary: Color(0xFF5D001E),
      primaryContainer: Color(0xFFFFDFE2),
      onPrimaryContainer: Color(0xFF5D001E),

      secondary: Color(0xFFFFDDB3), // melocotón pastel
      onSecondary: Color(0xFF5F2800),
      secondaryContainer: Color(0xFFFFEFE2),
      onSecondaryContainer: Color(0xFF5F2800),

      tertiary: Color(0xFFFFF3BA), // amarillo suave
      onTertiary: Color(0xFF5F5A00),
      tertiaryContainer: Color(0xFFFFFBE2),
      onTertiaryContainer: Color(0xFF5F5A00),

      // Neutral surfaces muy claros
      surface: Color(0xFFFFFCFC),
      onSurface: Color(0xFF2E1F1F),

      background: Color(0xFFFFFCFA),
      onBackground: Color(0xFF2E1F1F),

      error: Color(0xFFFFC9C9),
      onError: Color(0xFF670000),
      errorContainer: Color(0xFFFFE5E5),
      onErrorContainer: Color(0xFF670000),

      outline: Color(0xFFB59A9A),
      shadow: Color(0x33000000),
      surfaceTint: Color(0xFFFFB3BA),
      inverseSurface: Color(0xFF3F2D2D),
      inversePrimary: Color(0xFFB33A4F),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5d222d),
      surfaceTint: Color(0xff8e4954),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa05862),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4a2f32),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff866568),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4b310c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff88673e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff170f10),
      onSurfaceVariant: Color(0xff413334),
      outline: Color(0xff5e4f50),
      outlineVariant: Color(0xff7a696a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      inversePrimary: Color(0xffffb2bb),
      primaryFixed: Color(0xffa05862),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff83404a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff866568),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6b4d50),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff88673e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6d4f28),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd3c3c3),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f0),
      surfaceContainer: Color(0xfff6e4e5),
      surfaceContainerHigh: Color(0xffead9d9),
      surfaceContainerHighest: Color(0xffdfcece),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff511823),
      surfaceTint: Color(0xff8e4954),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff75353f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3f2528),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5f4145),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3f2704),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff60431d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff36292a),
      outlineVariant: Color(0xff544547),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      inversePrimary: Color(0xffffb2bb),
      primaryFixed: Color(0xff75353f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff591f29),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5f4145),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff462b2f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff60431d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff472d09),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5b5b6),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffeeded),
      surfaceContainer: Color(0xfff0dedf),
      surfaceContainerHigh: Color(0xffe1d0d1),
      surfaceContainerHighest: Color(0xffd3c3c3),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb2bb),
      surfaceTint: Color(0xffffb2bb),
      onPrimary: Color(0xff561d27),
      primaryContainer: Color(0xff72333d),
      onPrimaryContainer: Color(0xffffd9dc),
      secondary: Color(0xffe5bdc0),
      onSecondary: Color(0xff43292c),
      secondaryContainer: Color(0xff5c3f42),
      onSecondaryContainer: Color(0xffffd9dc),
      tertiary: Color(0xffe9bf8f),
      onTertiary: Color(0xff442b07),
      tertiaryContainer: Color(0xff5e411b),
      onTertiaryContainer: Color(0xffffddb7),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a1112),
      onSurface: Color(0xfff0dedf),
      onSurfaceVariant: Color(0xffd7c1c3),
      outline: Color(0xff9f8c8d),
      outlineVariant: Color(0xff524344),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      inversePrimary: Color(0xff8e4954),
      primaryFixed: Color(0xffffd9dc),
      onPrimaryFixed: Color(0xff3b0713),
      primaryFixedDim: Color(0xffffb2bb),
      onPrimaryFixedVariant: Color(0xff72333d),
      secondaryFixed: Color(0xffffd9dc),
      onSecondaryFixed: Color(0xff2c1518),
      secondaryFixedDim: Color(0xffe5bdc0),
      onSecondaryFixedVariant: Color(0xff5c3f42),
      tertiaryFixed: Color(0xffffddb7),
      onTertiaryFixed: Color(0xff2a1700),
      tertiaryFixedDim: Color(0xffe9bf8f),
      onTertiaryFixedVariant: Color(0xff5e411b),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff413737),
      surfaceContainerLowest: Color(0xff140c0d),
      surfaceContainerLow: Color(0xff22191a),
      surfaceContainer: Color(0xff261d1e),
      surfaceContainerHigh: Color(0xff312828),
      surfaceContainerHighest: Color(0xff3d3233),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd1d5),
      surfaceTint: Color(0xffffb2bb),
      onPrimary: Color(0xff48121d),
      primaryContainer: Color(0xffc97a84),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcd2d6),
      onSecondary: Color(0xff371f22),
      secondaryContainer: Color(0xffac888b),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd5a6),
      onTertiary: Color(0xff382100),
      tertiaryContainer: Color(0xffaf8a5e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1112),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffedd7d8),
      outline: Color(0xffc1adae),
      outlineVariant: Color(0xff9f8c8d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      inversePrimary: Color(0xff73343e),
      primaryFixed: Color(0xffffd9dc),
      onPrimaryFixed: Color(0xff2c0009),
      primaryFixedDim: Color(0xffffb2bb),
      onPrimaryFixedVariant: Color(0xff5d222d),
      secondaryFixed: Color(0xffffd9dc),
      onSecondaryFixed: Color(0xff200b0e),
      secondaryFixedDim: Color(0xffe5bdc0),
      onSecondaryFixedVariant: Color(0xff4a2f32),
      tertiaryFixed: Color(0xffffddb7),
      onTertiaryFixed: Color(0xff1c0e00),
      tertiaryFixedDim: Color(0xffe9bf8f),
      onTertiaryFixedVariant: Color(0xff4b310c),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff4d4243),
      surfaceContainerLowest: Color(0xff0c0606),
      surfaceContainerLow: Color(0xff241b1c),
      surfaceContainer: Color(0xff2f2526),
      surfaceContainerHigh: Color(0xff3a3031),
      surfaceContainerHighest: Color(0xff463b3c),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffebec),
      surfaceTint: Color(0xffffb2bb),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffacb6),
      onPrimaryContainer: Color(0xff210006),
      secondary: Color(0xffffebec),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe1b9bc),
      onSecondaryContainer: Color(0xff190608),
      tertiary: Color(0xffffeddc),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe5bb8b),
      onTertiaryContainer: Color(0xff140900),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1a1112),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffebec),
      outlineVariant: Color(0xffd3bebf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      inversePrimary: Color(0xff73343e),
      primaryFixed: Color(0xffffd9dc),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb2bb),
      onPrimaryFixedVariant: Color(0xff2c0009),
      secondaryFixed: Color(0xffffd9dc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe5bdc0),
      onSecondaryFixedVariant: Color(0xff200b0e),
      tertiaryFixed: Color(0xffffddb7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe9bf8f),
      onTertiaryFixedVariant: Color(0xff1c0e00),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff594d4e),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff261d1e),
      surfaceContainer: Color(0xff382e2f),
      surfaceContainerHigh: Color(0xff44393a),
      surfaceContainerHighest: Color(0xff4f4445),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
