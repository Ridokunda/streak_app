import 'package:flutter/services.dart';

class HapticsService {
  const HapticsService._();

  static Future<void> selection({required bool enabled}) async {
    if (enabled) await HapticFeedback.selectionClick();
  }

  static Future<void> success({required bool enabled}) async {
    if (enabled) await HapticFeedback.mediumImpact();
  }

  static Future<void> destructive({required bool enabled}) async {
    if (enabled) await HapticFeedback.heavyImpact();
  }
}
