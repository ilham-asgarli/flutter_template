import 'package:flutter/material.dart';

import '../../../ui/constants/colors/app_colors.dart';
import '../interfaces/custom_theme.dart';

class MainTheme extends CustomTheme {
  static final MainTheme instance = MainTheme._init();

  MainTheme._init();

  @override
  ThemeData getTheme({
    required ThemeData modeThemeData,
  }) {
    return modeThemeData.copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.mainColor,
      ),
    );
  }
}
