import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/router.dart';
import '../features/settings/theme_controller.dart';

class StartBotApp extends ConsumerWidget {
  const StartBotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Текущий режим темы из контроллера
    final appThemeMode = ref.watch(themeControllerProvider);
    final ThemeMode themeMode = () {
      switch (appThemeMode) {
        case AppThemeMode.light:
          return ThemeMode.light;
        case AppThemeMode.dark:
          return ThemeMode.dark;
        case AppThemeMode.system:
          return ThemeMode.system;
      }
    }();

    // Современная светлая тема с фиолетовой палитрой
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF7C3AED),
        onPrimary: Colors.white,
        secondary: Color(0xFFA78BFA),
        onSecondary: Color(0xFF1E1B27),
        error: Color(0xFFEF4444),
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFF111827),
        background: Color(0xFFF6F5FA),
        onBackground: Color(0xFF111827),
        tertiary: Color(0xFF6366F1),
        onTertiary: Colors.white,
        surfaceVariant: Color(0xFFF1EDF7),
        outline: Color(0xFFE7E3EE),
        outlineVariant: Color(0xFFE7E3EE),
        inverseSurface: Color(0xFF1E1B27),
        onInverseSurface: Color(0xFFF3F4F6),
        inversePrimary: Color(0xFF8B5CF6),
        scrim: Colors.black54,
        shadow: Colors.black26,
      ),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFFF6F5FA),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF111827),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF6B7280)),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFFE7E3EE), width: 1),
        ),
        margin: const EdgeInsets.all(16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF7C3AED),
          side: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF7C3AED),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1EDF7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE7E3EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE7E3EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(
          color: Color(0xFF9CA3AF),
          fontSize: 16,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF7C3AED).withOpacity(0.12),
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: Color(0xFF7C3AED));
          }
          return IconThemeData(color: Colors.grey.shade600);
        }),
      ),
    );

    // Темная тема с фиолетовой палитрой
    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFA78BFA),
        onPrimary: Color(0xFF12101A),
        secondary: Color(0xFF8B5CF6),
        onSecondary: Color(0xFF12101A),
        error: Color(0xFFF87171),
        onError: Color(0xFF12101A),
        surface: Color(0xFF1E1B27),
        onSurface: Color(0xFFF3F4F6),
        background: Color(0xFF12101A),
        onBackground: Color(0xFFF3F4F6),
        tertiary: Color(0xFF6366F1),
        onTertiary: Color(0xFF12101A),
        surfaceVariant: Color(0xFF242033),
        outline: Color(0xFF393449),
        outlineVariant: Color(0xFF393449),
        inverseSurface: Colors.white,
        onInverseSurface: Color(0xFF111827),
        inversePrimary: Color(0xFF7C3AED),
        scrim: Colors.black87,
        shadow: Colors.black54,
      ),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFF12101A),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1B27),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1B27),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF393449), width: 1),
        ),
        margin: const EdgeInsets.all(16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1B27),
        indicatorColor: const Color(0xFFA78BFA).withOpacity(0.18),
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: Color(0xFFA78BFA));
          }
          return const IconThemeData(color: Colors.white70);
        }),
      ),
    );

    // Текущая локаль приложения
    final Locale materialLocale = context.locale;

    return MaterialApp.router(
      title: 'StartBot',
      routerConfig: appRouter,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: materialLocale,
      debugShowCheckedModeBanner: false,
    );
  }
}


