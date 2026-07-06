import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/settings/data/models/app_settings.dart';
import '../../features/streaks/data/models/completion.dart';
import '../../features/streaks/data/models/streak.dart';

class IsarDatabase {
  static Isar? _isar;

  static Future<Isar> instance() async {
    if (_isar != null) {
      return _isar!;
    }

    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance();
      return _isar!;
    }

    final directory = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        StreakSchema,
        CompletionSchema,
        AppSettingsSchema,
      ],
      directory: directory.path,
      inspector: kDebugMode,
    );

    return _isar!;
  }
}