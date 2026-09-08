import 'package:material_ui/material_ui.dart';
import 'package:openra_launcher/constants/app_constants.dart';

TextStyle _chipLabelStyle(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: brightness,
  );
  return AppConstants.chipTextStyle.copyWith(color: scheme.onSurfaceVariant);
}

ThemeData buildAppTheme(Brightness brightness) => ThemeData(
  colorSchemeSeed: Colors.red,
  brightness: brightness,
  cardTheme: CardThemeData(shape: AppConstants.roundedRectangleBorder),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(shape: AppConstants.roundedRectangleBorder),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(shape: AppConstants.roundedRectangleBorder),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(shape: AppConstants.roundedRectangleBorder),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: UnderlineInputBorder(borderSide: BorderSide()),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide()),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide()),
  ),
  chipTheme: ChipThemeData(
    shape: AppConstants.roundedRectangleBorder,
    labelStyle: _chipLabelStyle(brightness),
  ),
  dialogTheme: DialogThemeData(shape: AppConstants.roundedRectangleBorder),
  bottomSheetTheme: BottomSheetThemeData(
    shape: AppConstants.roundedRectangleBorder,
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorShape: AppConstants.roundedRectangleBorder,
  ),
  navigationRailTheme: NavigationRailThemeData(
    indicatorShape: AppConstants.roundedRectangleBorder,
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(
      shape: AppConstants.roundedRectangleBorder,
    ),
  ),
);
