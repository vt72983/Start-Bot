import 'package:flutter/material.dart';

/// Константы дизайна приложения
class AppDesign {
  // Цветовая палитра
  static const Color primaryColor = Color(0xFF7C3AED);
  static const Color secondaryColor = Color(0xFFA78BFA);
  static const Color accentColor = Color(0xFF6366F1);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);
  
  // Градиенты
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF8B5CF6),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFFA78BFA),
    ],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFD97706),
    ],
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEF4444),
      Color(0xFFDC2626),
    ],
  );
  
  // Радиусы скругления
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Отступы
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Размеры иконок
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 32.0;
  
  // Размеры шрифтов
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeXXXLarge = 32.0;
  
  // Тени
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];
  
  static const List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: Color(0x4D6366F1),
      blurRadius: 30,
      offset: Offset(0, 15),
    ),
  ];
  
  // Анимации
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 400);
  static const Duration animationSlow = Duration(milliseconds: 600);
  static const Duration animationXSlow = Duration(milliseconds: 800);
  
  // Кривые анимации
  static const Curve animationCurve = Curves.easeOutCubic;
  static const Curve elasticCurve = Curves.elasticOut;
  
  // Стили текста
  static const TextStyle headlineStyle = TextStyle(
    fontSize: fontSizeXXXLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: fontSizeXXLarge,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeLarge,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: fontSizeMedium,
    color: Colors.grey,
  );
  
  static const TextStyle smallStyle = TextStyle(
    fontSize: fontSizeSmall,
    color: Colors.grey,
  );
  
  // Декорации карточек
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusLarge),
    border: Border.all(
      color: Colors.grey.shade200,
      width: 1,
    ),
    boxShadow: cardShadow,
  );
  
  static BoxDecoration gradientCardDecoration = BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: primaryShadow,
  );
  
  // Декорации кнопок
  static BoxDecoration gradientButtonDecoration = BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(radiusMedium),
    boxShadow: cardShadow,
  );
  
  static BoxDecoration outlinedButtonDecoration = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(radiusMedium),
    border: Border.all(
      color: primaryColor,
      width: 1,
    ),
  );
  
  // Декорации полей ввода
  static InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: const BorderSide(
        color: primaryColor,
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: paddingMedium,
      vertical: paddingMedium,
    ),
  );
}
