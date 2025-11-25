import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';

class AppTextStyles {
  // Titulos
  static const TextStyle titleLarge = TextStyle(
    fontSize: AppDimens.fontSizeTitleLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDarker,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: AppDimens.fontSizeTitleMedium,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDarker,
  );

  // Subtitulos
  static const TextStyle subtitle = TextStyle(
    fontSize: AppDimens.fontSizeSubtitle,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDarker,
  );

  // Cuerpo
  static const TextStyle body = TextStyle(
    fontSize: AppDimens.fontSizeBody,
    color: AppColors.primaryDarker,
  );

  static const TextStyle bodyLight = TextStyle(
    fontSize: AppDimens.fontSizeBody,
    color: AppColors.primaryDarker,
    fontWeight: FontWeight.w400,
  );

  // Texto pequeño
  static const TextStyle small = TextStyle(
    fontSize: AppDimens.fontSizeSmall,
    color: AppColors.primaryDarker,
  );

  // Boton de texto
  static const TextStyle button = TextStyle(
    fontSize: AppDimens.fontSizeSubtitle,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}
