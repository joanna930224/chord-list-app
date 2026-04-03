import 'package:chord_list_app/shared/exports.dart';

class AppTheme {
  static ThemeData light(BuildContext context) => ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Pretendard',
    colorScheme: const ColorScheme.light(
      primary: AppColors.grey900,
      onPrimary: Colors.white,
      secondary: AppColors.grey600,
      onSecondary: Colors.white,
      tertiary: AppColors.grey400,
      onTertiary: Colors.white,
      surface: AppColors.grey50,
      onSurface: AppColors.grey950,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.grey200,
      shadow: Colors.black,
      inverseSurface: AppColors.grey950,
      onInverseSurface: Colors.white,
    ),
    splashColor: Colors.transparent,
    highlightColor: AppColors.grey400.withAlpha(25),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      titleTextStyle: context.textTheme.regular16.copyWith(
        color: AppColors.grey950,
      ),
      iconTheme: IconThemeData(color: AppColors.grey950, size: 20),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
      space: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.grey950,
        shadowColor: Colors.transparent,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey200, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey200, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey900, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brand;
        }
        return AppColors.grey100;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );

  static ThemeData dark(BuildContext context) => ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Pretendard',
    textTheme: TextTheme(titleMedium: context.textTheme.regular16),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: AppColors.grey900,
      secondary: AppColors.grey300,
      onSecondary: AppColors.grey950,
      tertiary: AppColors.grey400,
      onTertiary: AppColors.grey950,
      surface: AppColors.grey950,
      onSurface: AppColors.grey100,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.grey600,
      shadow: Colors.black,
      inverseSurface: AppColors.grey100,
      onInverseSurface: AppColors.grey950,
    ),
    splashColor: Colors.transparent,
    highlightColor: AppColors.grey400.withAlpha(25),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      titleTextStyle: context.textTheme.regular16.copyWith(
        color: AppColors.grey100,
      ),
      iconTheme: IconThemeData(color: AppColors.grey100, size: 20),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.grey600,
      thickness: 1,
      space: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey900,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.grey950,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey900,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey600, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey600, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.0),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brand;
        }
        return AppColors.grey600;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}
