import 'package:flutter/services.dart';

/// Servicio para manejar feedback háptico
class HapticService {
  /// Vibración ligera para interacciones normales
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  /// Vibración media para acciones importantes
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  /// Vibración fuerte para matches y acciones especiales
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  /// Vibración de selección
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  /// Vibración de éxito (para matches)
  static Future<void> matchVibration() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Vibración para like
  static void likeVibration() {
    HapticFeedback.mediumImpact();
  }

  /// Vibración para dislike
  static void dislikeVibration() {
    HapticFeedback.lightImpact();
  }
}
