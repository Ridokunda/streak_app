// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $StreaksTableTable extends StreaksTable
    with TableInfo<$StreaksTableTable, StreaksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDaysMeta =
      const VerificationMeta('scheduledDays');
  @override
  late final GeneratedColumn<String> scheduledDays = GeneratedColumn<String>(
      'scheduled_days', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _reminderHourMeta =
      const VerificationMeta('reminderHour');
  @override
  late final GeneratedColumn<int> reminderHour = GeneratedColumn<int>(
      'reminder_hour', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(20));
  static const VerificationMeta _reminderMinuteMeta =
      const VerificationMeta('reminderMinute');
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
      'reminder_minute', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remindersEnabledMeta =
      const VerificationMeta('remindersEnabled');
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
      'reminders_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminders_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reminderTimesMeta =
      const VerificationMeta('reminderTimes');
  @override
  late final GeneratedColumn<String> reminderTimes = GeneratedColumn<String>(
      'reminder_times', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastCompletedMeta =
      const VerificationMeta('lastCompleted');
  @override
  late final GeneratedColumn<DateTime> lastCompleted =
      GeneratedColumn<DateTime>('last_completed', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastFreezeUsedMeta =
      const VerificationMeta('lastFreezeUsed');
  @override
  late final GeneratedColumn<DateTime> lastFreezeUsed =
      GeneratedColumn<DateTime>('last_freeze_used', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _currentStreakMeta =
      const VerificationMeta('currentStreak');
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
      'current_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _longestStreakMeta =
      const VerificationMeta('longestStreak');
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
      'longest_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _freezeCountMeta =
      const VerificationMeta('freezeCount');
  @override
  late final GeneratedColumn<int> freezeCount = GeneratedColumn<int>(
      'freeze_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedSinceFreezeMeta =
      const VerificationMeta('completedSinceFreeze');
  @override
  late final GeneratedColumn<int> completedSinceFreeze = GeneratedColumn<int>(
      'completed_since_freeze', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _archivedMeta =
      const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
      'archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        frequency,
        scheduledDays,
        reminderHour,
        reminderMinute,
        remindersEnabled,
        reminderTimes,
        createdAt,
        lastCompleted,
        lastFreezeUsed,
        currentStreak,
        longestStreak,
        freezeCount,
        completedSinceFreeze,
        archived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks_table';
  @override
  VerificationContext validateIntegrity(Insertable<StreaksTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
          _scheduledDaysMeta,
          scheduledDays.isAcceptableOrUnknown(
              data['scheduled_days']!, _scheduledDaysMeta));
    }
    if (data.containsKey('reminder_hour')) {
      context.handle(
          _reminderHourMeta,
          reminderHour.isAcceptableOrUnknown(
              data['reminder_hour']!, _reminderHourMeta));
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
          _reminderMinuteMeta,
          reminderMinute.isAcceptableOrUnknown(
              data['reminder_minute']!, _reminderMinuteMeta));
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
          _remindersEnabledMeta,
          remindersEnabled.isAcceptableOrUnknown(
              data['reminders_enabled']!, _remindersEnabledMeta));
    }
    if (data.containsKey('reminder_times')) {
      context.handle(
          _reminderTimesMeta,
          reminderTimes.isAcceptableOrUnknown(
              data['reminder_times']!, _reminderTimesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_completed')) {
      context.handle(
          _lastCompletedMeta,
          lastCompleted.isAcceptableOrUnknown(
              data['last_completed']!, _lastCompletedMeta));
    }
    if (data.containsKey('last_freeze_used')) {
      context.handle(
          _lastFreezeUsedMeta,
          lastFreezeUsed.isAcceptableOrUnknown(
              data['last_freeze_used']!, _lastFreezeUsedMeta));
    }
    if (data.containsKey('current_streak')) {
      context.handle(
          _currentStreakMeta,
          currentStreak.isAcceptableOrUnknown(
              data['current_streak']!, _currentStreakMeta));
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
          _longestStreakMeta,
          longestStreak.isAcceptableOrUnknown(
              data['longest_streak']!, _longestStreakMeta));
    }
    if (data.containsKey('freeze_count')) {
      context.handle(
          _freezeCountMeta,
          freezeCount.isAcceptableOrUnknown(
              data['freeze_count']!, _freezeCountMeta));
    }
    if (data.containsKey('completed_since_freeze')) {
      context.handle(
          _completedSinceFreezeMeta,
          completedSinceFreeze.isAcceptableOrUnknown(
              data['completed_since_freeze']!, _completedSinceFreezeMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreaksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreaksTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      scheduledDays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scheduled_days'])!,
      reminderHour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_hour'])!,
      reminderMinute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_minute'])!,
      remindersEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}reminders_enabled'])!,
      reminderTimes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_times'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_completed']),
      lastFreezeUsed: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_freeze_used']),
      currentStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_streak'])!,
      longestStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_streak'])!,
      freezeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}freeze_count'])!,
      completedSinceFreeze: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}completed_since_freeze'])!,
      archived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
    );
  }

  @override
  $StreaksTableTable createAlias(String alias) {
    return $StreaksTableTable(attachedDatabase, alias);
  }
}

class StreaksTableData extends DataClass
    implements Insertable<StreaksTableData> {
  final int id;
  final String title;
  final String? description;
  final String frequency;
  final String scheduledDays;
  final int reminderHour;
  final int reminderMinute;
  final bool remindersEnabled;
  final String reminderTimes;
  final DateTime createdAt;
  final DateTime? lastCompleted;
  final DateTime? lastFreezeUsed;
  final int currentStreak;
  final int longestStreak;
  final int freezeCount;
  final int completedSinceFreeze;
  final bool archived;
  const StreaksTableData(
      {required this.id,
      required this.title,
      this.description,
      required this.frequency,
      required this.scheduledDays,
      required this.reminderHour,
      required this.reminderMinute,
      required this.remindersEnabled,
      required this.reminderTimes,
      required this.createdAt,
      this.lastCompleted,
      this.lastFreezeUsed,
      required this.currentStreak,
      required this.longestStreak,
      required this.freezeCount,
      required this.completedSinceFreeze,
      required this.archived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['frequency'] = Variable<String>(frequency);
    map['scheduled_days'] = Variable<String>(scheduledDays);
    map['reminder_hour'] = Variable<int>(reminderHour);
    map['reminder_minute'] = Variable<int>(reminderMinute);
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    map['reminder_times'] = Variable<String>(reminderTimes);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastCompleted != null) {
      map['last_completed'] = Variable<DateTime>(lastCompleted);
    }
    if (!nullToAbsent || lastFreezeUsed != null) {
      map['last_freeze_used'] = Variable<DateTime>(lastFreezeUsed);
    }
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['freeze_count'] = Variable<int>(freezeCount);
    map['completed_since_freeze'] = Variable<int>(completedSinceFreeze);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  StreaksTableCompanion toCompanion(bool nullToAbsent) {
    return StreaksTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      frequency: Value(frequency),
      scheduledDays: Value(scheduledDays),
      reminderHour: Value(reminderHour),
      reminderMinute: Value(reminderMinute),
      remindersEnabled: Value(remindersEnabled),
      reminderTimes: Value(reminderTimes),
      createdAt: Value(createdAt),
      lastCompleted: lastCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompleted),
      lastFreezeUsed: lastFreezeUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFreezeUsed),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      freezeCount: Value(freezeCount),
      completedSinceFreeze: Value(completedSinceFreeze),
      archived: Value(archived),
    );
  }

  factory StreaksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreaksTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      frequency: serializer.fromJson<String>(json['frequency']),
      scheduledDays: serializer.fromJson<String>(json['scheduledDays']),
      reminderHour: serializer.fromJson<int>(json['reminderHour']),
      reminderMinute: serializer.fromJson<int>(json['reminderMinute']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      reminderTimes: serializer.fromJson<String>(json['reminderTimes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastCompleted: serializer.fromJson<DateTime?>(json['lastCompleted']),
      lastFreezeUsed: serializer.fromJson<DateTime?>(json['lastFreezeUsed']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      freezeCount: serializer.fromJson<int>(json['freezeCount']),
      completedSinceFreeze:
          serializer.fromJson<int>(json['completedSinceFreeze']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'frequency': serializer.toJson<String>(frequency),
      'scheduledDays': serializer.toJson<String>(scheduledDays),
      'reminderHour': serializer.toJson<int>(reminderHour),
      'reminderMinute': serializer.toJson<int>(reminderMinute),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'reminderTimes': serializer.toJson<String>(reminderTimes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastCompleted': serializer.toJson<DateTime?>(lastCompleted),
      'lastFreezeUsed': serializer.toJson<DateTime?>(lastFreezeUsed),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'freezeCount': serializer.toJson<int>(freezeCount),
      'completedSinceFreeze': serializer.toJson<int>(completedSinceFreeze),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  StreaksTableData copyWith(
          {int? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? frequency,
          String? scheduledDays,
          int? reminderHour,
          int? reminderMinute,
          bool? remindersEnabled,
          String? reminderTimes,
          DateTime? createdAt,
          Value<DateTime?> lastCompleted = const Value.absent(),
          Value<DateTime?> lastFreezeUsed = const Value.absent(),
          int? currentStreak,
          int? longestStreak,
          int? freezeCount,
          int? completedSinceFreeze,
          bool? archived}) =>
      StreaksTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        frequency: frequency ?? this.frequency,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        reminderHour: reminderHour ?? this.reminderHour,
        reminderMinute: reminderMinute ?? this.reminderMinute,
        remindersEnabled: remindersEnabled ?? this.remindersEnabled,
        reminderTimes: reminderTimes ?? this.reminderTimes,
        createdAt: createdAt ?? this.createdAt,
        lastCompleted:
            lastCompleted.present ? lastCompleted.value : this.lastCompleted,
        lastFreezeUsed:
            lastFreezeUsed.present ? lastFreezeUsed.value : this.lastFreezeUsed,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        freezeCount: freezeCount ?? this.freezeCount,
        completedSinceFreeze: completedSinceFreeze ?? this.completedSinceFreeze,
        archived: archived ?? this.archived,
      );
  StreaksTableData copyWithCompanion(StreaksTableCompanion data) {
    return StreaksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      reminderHour: data.reminderHour.present
          ? data.reminderHour.value
          : this.reminderHour,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      reminderTimes: data.reminderTimes.present
          ? data.reminderTimes.value
          : this.reminderTimes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastCompleted: data.lastCompleted.present
          ? data.lastCompleted.value
          : this.lastCompleted,
      lastFreezeUsed: data.lastFreezeUsed.present
          ? data.lastFreezeUsed.value
          : this.lastFreezeUsed,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      freezeCount:
          data.freezeCount.present ? data.freezeCount.value : this.freezeCount,
      completedSinceFreeze: data.completedSinceFreeze.present
          ? data.completedSinceFreeze.value
          : this.completedSinceFreeze,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreaksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('reminderTimes: $reminderTimes, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastCompleted: $lastCompleted, ')
          ..write('lastFreezeUsed: $lastFreezeUsed, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('freezeCount: $freezeCount, ')
          ..write('completedSinceFreeze: $completedSinceFreeze, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      frequency,
      scheduledDays,
      reminderHour,
      reminderMinute,
      remindersEnabled,
      reminderTimes,
      createdAt,
      lastCompleted,
      lastFreezeUsed,
      currentStreak,
      longestStreak,
      freezeCount,
      completedSinceFreeze,
      archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreaksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.frequency == this.frequency &&
          other.scheduledDays == this.scheduledDays &&
          other.reminderHour == this.reminderHour &&
          other.reminderMinute == this.reminderMinute &&
          other.remindersEnabled == this.remindersEnabled &&
          other.reminderTimes == this.reminderTimes &&
          other.createdAt == this.createdAt &&
          other.lastCompleted == this.lastCompleted &&
          other.lastFreezeUsed == this.lastFreezeUsed &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.freezeCount == this.freezeCount &&
          other.completedSinceFreeze == this.completedSinceFreeze &&
          other.archived == this.archived);
}

class StreaksTableCompanion extends UpdateCompanion<StreaksTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> frequency;
  final Value<String> scheduledDays;
  final Value<int> reminderHour;
  final Value<int> reminderMinute;
  final Value<bool> remindersEnabled;
  final Value<String> reminderTimes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastCompleted;
  final Value<DateTime?> lastFreezeUsed;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<int> freezeCount;
  final Value<int> completedSinceFreeze;
  final Value<bool> archived;
  const StreaksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.frequency = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.reminderTimes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastCompleted = const Value.absent(),
    this.lastFreezeUsed = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.freezeCount = const Value.absent(),
    this.completedSinceFreeze = const Value.absent(),
    this.archived = const Value.absent(),
  });
  StreaksTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String frequency,
    this.scheduledDays = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.reminderTimes = const Value.absent(),
    required DateTime createdAt,
    this.lastCompleted = const Value.absent(),
    this.lastFreezeUsed = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.freezeCount = const Value.absent(),
    this.completedSinceFreeze = const Value.absent(),
    this.archived = const Value.absent(),
  })  : title = Value(title),
        frequency = Value(frequency),
        createdAt = Value(createdAt);
  static Insertable<StreaksTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? frequency,
    Expression<String>? scheduledDays,
    Expression<int>? reminderHour,
    Expression<int>? reminderMinute,
    Expression<bool>? remindersEnabled,
    Expression<String>? reminderTimes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastCompleted,
    Expression<DateTime>? lastFreezeUsed,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<int>? freezeCount,
    Expression<int>? completedSinceFreeze,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (frequency != null) 'frequency': frequency,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (reminderHour != null) 'reminder_hour': reminderHour,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (reminderTimes != null) 'reminder_times': reminderTimes,
      if (createdAt != null) 'created_at': createdAt,
      if (lastCompleted != null) 'last_completed': lastCompleted,
      if (lastFreezeUsed != null) 'last_freeze_used': lastFreezeUsed,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (freezeCount != null) 'freeze_count': freezeCount,
      if (completedSinceFreeze != null)
        'completed_since_freeze': completedSinceFreeze,
      if (archived != null) 'archived': archived,
    });
  }

  StreaksTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? frequency,
      Value<String>? scheduledDays,
      Value<int>? reminderHour,
      Value<int>? reminderMinute,
      Value<bool>? remindersEnabled,
      Value<String>? reminderTimes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastCompleted,
      Value<DateTime?>? lastFreezeUsed,
      Value<int>? currentStreak,
      Value<int>? longestStreak,
      Value<int>? freezeCount,
      Value<int>? completedSinceFreeze,
      Value<bool>? archived}) {
    return StreaksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      createdAt: createdAt ?? this.createdAt,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      lastFreezeUsed: lastFreezeUsed ?? this.lastFreezeUsed,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      freezeCount: freezeCount ?? this.freezeCount,
      completedSinceFreeze: completedSinceFreeze ?? this.completedSinceFreeze,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<String>(scheduledDays.value);
    }
    if (reminderHour.present) {
      map['reminder_hour'] = Variable<int>(reminderHour.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (reminderTimes.present) {
      map['reminder_times'] = Variable<String>(reminderTimes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastCompleted.present) {
      map['last_completed'] = Variable<DateTime>(lastCompleted.value);
    }
    if (lastFreezeUsed.present) {
      map['last_freeze_used'] = Variable<DateTime>(lastFreezeUsed.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (freezeCount.present) {
      map['freeze_count'] = Variable<int>(freezeCount.value);
    }
    if (completedSinceFreeze.present) {
      map['completed_since_freeze'] = Variable<int>(completedSinceFreeze.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('reminderTimes: $reminderTimes, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastCompleted: $lastCompleted, ')
          ..write('lastFreezeUsed: $lastFreezeUsed, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('freezeCount: $freezeCount, ')
          ..write('completedSinceFreeze: $completedSinceFreeze, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $CompletionsTableTable extends CompletionsTable
    with TableInfo<$CompletionsTableTable, CompletionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _streakIdMeta =
      const VerificationMeta('streakId');
  @override
  late final GeneratedColumn<int> streakId = GeneratedColumn<int>(
      'streak_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedDateMeta =
      const VerificationMeta('completedDate');
  @override
  late final GeneratedColumn<DateTime> completedDate =
      GeneratedColumn<DateTime>('completed_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _usedFreezeMeta =
      const VerificationMeta('usedFreeze');
  @override
  late final GeneratedColumn<bool> usedFreeze = GeneratedColumn<bool>(
      'used_freeze', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("used_freeze" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, streakId, completedDate, usedFreeze];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CompletionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('streak_id')) {
      context.handle(_streakIdMeta,
          streakId.isAcceptableOrUnknown(data['streak_id']!, _streakIdMeta));
    } else if (isInserting) {
      context.missing(_streakIdMeta);
    }
    if (data.containsKey('completed_date')) {
      context.handle(
          _completedDateMeta,
          completedDate.isAcceptableOrUnknown(
              data['completed_date']!, _completedDateMeta));
    } else if (isInserting) {
      context.missing(_completedDateMeta);
    }
    if (data.containsKey('used_freeze')) {
      context.handle(
          _usedFreezeMeta,
          usedFreeze.isAcceptableOrUnknown(
              data['used_freeze']!, _usedFreezeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompletionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      streakId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_id'])!,
      completedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}completed_date'])!,
      usedFreeze: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}used_freeze'])!,
    );
  }

  @override
  $CompletionsTableTable createAlias(String alias) {
    return $CompletionsTableTable(attachedDatabase, alias);
  }
}

class CompletionsTableData extends DataClass
    implements Insertable<CompletionsTableData> {
  final int id;
  final int streakId;
  final DateTime completedDate;
  final bool usedFreeze;
  const CompletionsTableData(
      {required this.id,
      required this.streakId,
      required this.completedDate,
      required this.usedFreeze});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['streak_id'] = Variable<int>(streakId);
    map['completed_date'] = Variable<DateTime>(completedDate);
    map['used_freeze'] = Variable<bool>(usedFreeze);
    return map;
  }

  CompletionsTableCompanion toCompanion(bool nullToAbsent) {
    return CompletionsTableCompanion(
      id: Value(id),
      streakId: Value(streakId),
      completedDate: Value(completedDate),
      usedFreeze: Value(usedFreeze),
    );
  }

  factory CompletionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletionsTableData(
      id: serializer.fromJson<int>(json['id']),
      streakId: serializer.fromJson<int>(json['streakId']),
      completedDate: serializer.fromJson<DateTime>(json['completedDate']),
      usedFreeze: serializer.fromJson<bool>(json['usedFreeze']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streakId': serializer.toJson<int>(streakId),
      'completedDate': serializer.toJson<DateTime>(completedDate),
      'usedFreeze': serializer.toJson<bool>(usedFreeze),
    };
  }

  CompletionsTableData copyWith(
          {int? id,
          int? streakId,
          DateTime? completedDate,
          bool? usedFreeze}) =>
      CompletionsTableData(
        id: id ?? this.id,
        streakId: streakId ?? this.streakId,
        completedDate: completedDate ?? this.completedDate,
        usedFreeze: usedFreeze ?? this.usedFreeze,
      );
  CompletionsTableData copyWithCompanion(CompletionsTableCompanion data) {
    return CompletionsTableData(
      id: data.id.present ? data.id.value : this.id,
      streakId: data.streakId.present ? data.streakId.value : this.streakId,
      completedDate: data.completedDate.present
          ? data.completedDate.value
          : this.completedDate,
      usedFreeze:
          data.usedFreeze.present ? data.usedFreeze.value : this.usedFreeze,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsTableData(')
          ..write('id: $id, ')
          ..write('streakId: $streakId, ')
          ..write('completedDate: $completedDate, ')
          ..write('usedFreeze: $usedFreeze')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, streakId, completedDate, usedFreeze);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletionsTableData &&
          other.id == this.id &&
          other.streakId == this.streakId &&
          other.completedDate == this.completedDate &&
          other.usedFreeze == this.usedFreeze);
}

class CompletionsTableCompanion extends UpdateCompanion<CompletionsTableData> {
  final Value<int> id;
  final Value<int> streakId;
  final Value<DateTime> completedDate;
  final Value<bool> usedFreeze;
  const CompletionsTableCompanion({
    this.id = const Value.absent(),
    this.streakId = const Value.absent(),
    this.completedDate = const Value.absent(),
    this.usedFreeze = const Value.absent(),
  });
  CompletionsTableCompanion.insert({
    this.id = const Value.absent(),
    required int streakId,
    required DateTime completedDate,
    this.usedFreeze = const Value.absent(),
  })  : streakId = Value(streakId),
        completedDate = Value(completedDate);
  static Insertable<CompletionsTableData> custom({
    Expression<int>? id,
    Expression<int>? streakId,
    Expression<DateTime>? completedDate,
    Expression<bool>? usedFreeze,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streakId != null) 'streak_id': streakId,
      if (completedDate != null) 'completed_date': completedDate,
      if (usedFreeze != null) 'used_freeze': usedFreeze,
    });
  }

  CompletionsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? streakId,
      Value<DateTime>? completedDate,
      Value<bool>? usedFreeze}) {
    return CompletionsTableCompanion(
      id: id ?? this.id,
      streakId: streakId ?? this.streakId,
      completedDate: completedDate ?? this.completedDate,
      usedFreeze: usedFreeze ?? this.usedFreeze,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streakId.present) {
      map['streak_id'] = Variable<int>(streakId.value);
    }
    if (completedDate.present) {
      map['completed_date'] = Variable<DateTime>(completedDate.value);
    }
    if (usedFreeze.present) {
      map['used_freeze'] = Variable<bool>(usedFreeze.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsTableCompanion(')
          ..write('id: $id, ')
          ..write('streakId: $streakId, ')
          ..write('completedDate: $completedDate, ')
          ..write('usedFreeze: $usedFreeze')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _darkModeMeta =
      const VerificationMeta('darkMode');
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
      'dark_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dark_mode" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _hapticsEnabledMeta =
      const VerificationMeta('hapticsEnabled');
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
      'haptics_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("haptics_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, darkMode, notificationsEnabled, hapticsEnabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dark_mode')) {
      context.handle(_darkModeMeta,
          darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
          _hapticsEnabledMeta,
          hapticsEnabled.isAcceptableOrUnknown(
              data['haptics_enabled']!, _hapticsEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      darkMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dark_mode'])!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
      hapticsEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}haptics_enabled'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int id;
  final bool darkMode;
  final bool notificationsEnabled;
  final bool hapticsEnabled;
  const AppSettingsTableData(
      {required this.id,
      required this.darkMode,
      required this.notificationsEnabled,
      required this.hapticsEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dark_mode'] = Variable<bool>(darkMode);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      darkMode: Value(darkMode),
      notificationsEnabled: Value(notificationsEnabled),
      hapticsEnabled: Value(hapticsEnabled),
    );
  }

  factory AppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'darkMode': serializer.toJson<bool>(darkMode),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
    };
  }

  AppSettingsTableData copyWith(
          {int? id,
          bool? darkMode,
          bool? notificationsEnabled,
          bool? hapticsEnabled}) =>
      AppSettingsTableData(
        id: id ?? this.id,
        darkMode: darkMode ?? this.darkMode,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('darkMode: $darkMode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, darkMode, notificationsEnabled, hapticsEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.darkMode == this.darkMode &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.hapticsEnabled == this.hapticsEnabled);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> id;
  final Value<bool> darkMode;
  final Value<bool> notificationsEnabled;
  final Value<bool> hapticsEnabled;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? id,
    Expression<bool>? darkMode,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? hapticsEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (darkMode != null) 'dark_mode': darkMode,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<bool>? darkMode,
      Value<bool>? notificationsEnabled,
      Value<bool>? hapticsEnabled,
      Value<int>? rowid}) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('darkMode: $darkMode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTableTable extends AchievementsTable
    with TableInfo<$AchievementsTableTable, AchievementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AchievementsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AchievementsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementsTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $AchievementsTableTable createAlias(String alias) {
    return $AchievementsTableTable(attachedDatabase, alias);
  }
}

class AchievementsTableData extends DataClass
    implements Insertable<AchievementsTableData> {
  final String key;
  final DateTime unlockedAt;
  const AchievementsTableData({required this.key, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  AchievementsTableCompanion toCompanion(bool nullToAbsent) {
    return AchievementsTableCompanion(
      key: Value(key),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory AchievementsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementsTableData(
      key: serializer.fromJson<String>(json['key']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  AchievementsTableData copyWith({String? key, DateTime? unlockedAt}) =>
      AchievementsTableData(
        key: key ?? this.key,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  AchievementsTableData copyWithCompanion(AchievementsTableCompanion data) {
    return AchievementsTableData(
      key: data.key.present ? data.key.value : this.key,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableData(')
          ..write('key: $key, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementsTableData &&
          other.key == this.key &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsTableCompanion
    extends UpdateCompanion<AchievementsTableData> {
  final Value<String> key;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const AchievementsTableCompanion({
    this.key = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsTableCompanion.insert({
    required String key,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        unlockedAt = Value(unlockedAt);
  static Insertable<AchievementsTableData> custom({
    Expression<String>? key,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsTableCompanion copyWith(
      {Value<String>? key, Value<DateTime>? unlockedAt, Value<int>? rowid}) {
    return AchievementsTableCompanion(
      key: key ?? this.key,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableCompanion(')
          ..write('key: $key, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTableTable extends TodosTable
    with TableInfo<$TodosTableTable, TodosTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reminderEnabledMeta =
      const VerificationMeta('reminderEnabled');
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
      'reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reminderAtMeta =
      const VerificationMeta('reminderAt');
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
      'reminder_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, isCompleted, reminderEnabled, reminderAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos_table';
  @override
  VerificationContext validateIntegrity(Insertable<TodosTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
          _reminderEnabledMeta,
          reminderEnabled.isAcceptableOrUnknown(
              data['reminder_enabled']!, _reminderEnabledMeta));
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
          _reminderAtMeta,
          reminderAt.isAcceptableOrUnknown(
              data['reminder_at']!, _reminderAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodosTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodosTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      reminderEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reminder_enabled'])!,
      reminderAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TodosTableTable createAlias(String alias) {
    return $TodosTableTable(attachedDatabase, alias);
  }
}

class TodosTableData extends DataClass implements Insertable<TodosTableData> {
  final int id;
  final String title;
  final bool isCompleted;
  final bool reminderEnabled;
  final DateTime? reminderAt;
  final DateTime createdAt;
  const TodosTableData(
      {required this.id,
      required this.title,
      required this.isCompleted,
      required this.reminderEnabled,
      this.reminderAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TodosTableCompanion toCompanion(bool nullToAbsent) {
    return TodosTableCompanion(
      id: Value(id),
      title: Value(title),
      isCompleted: Value(isCompleted),
      reminderEnabled: Value(reminderEnabled),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      createdAt: Value(createdAt),
    );
  }

  factory TodosTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodosTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TodosTableData copyWith(
          {int? id,
          String? title,
          bool? isCompleted,
          bool? reminderEnabled,
          Value<DateTime?> reminderAt = const Value.absent(),
          DateTime? createdAt}) =>
      TodosTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
        createdAt: createdAt ?? this.createdAt,
      );
  TodosTableData copyWithCompanion(TodosTableCompanion data) {
    return TodosTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderAt:
          data.reminderAt.present ? data.reminderAt.value : this.reminderAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodosTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, isCompleted, reminderEnabled, reminderAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodosTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.isCompleted == this.isCompleted &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderAt == this.reminderAt &&
          other.createdAt == this.createdAt);
}

class TodosTableCompanion extends UpdateCompanion<TodosTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<bool> isCompleted;
  final Value<bool> reminderEnabled;
  final Value<DateTime?> reminderAt;
  final Value<DateTime> createdAt;
  const TodosTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TodosTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.isCompleted = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderAt = const Value.absent(),
    required DateTime createdAt,
  })  : title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<TodosTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<bool>? isCompleted,
    Expression<bool>? reminderEnabled,
    Expression<DateTime>? reminderAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TodosTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<bool>? isCompleted,
      Value<bool>? reminderEnabled,
      Value<DateTime?>? reminderAt,
      Value<DateTime>? createdAt}) {
    return TodosTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderAt: reminderAt ?? this.reminderAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StreaksTableTable streaksTable = $StreaksTableTable(this);
  late final $CompletionsTableTable completionsTable =
      $CompletionsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  late final $AchievementsTableTable achievementsTable =
      $AchievementsTableTable(this);
  late final $TodosTableTable todosTable = $TodosTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        streaksTable,
        completionsTable,
        appSettingsTable,
        achievementsTable,
        todosTable
      ];
}

typedef $$StreaksTableTableCreateCompanionBuilder = StreaksTableCompanion
    Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  required String frequency,
  Value<String> scheduledDays,
  Value<int> reminderHour,
  Value<int> reminderMinute,
  Value<bool> remindersEnabled,
  Value<String> reminderTimes,
  required DateTime createdAt,
  Value<DateTime?> lastCompleted,
  Value<DateTime?> lastFreezeUsed,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<int> freezeCount,
  Value<int> completedSinceFreeze,
  Value<bool> archived,
});
typedef $$StreaksTableTableUpdateCompanionBuilder = StreaksTableCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<String> frequency,
  Value<String> scheduledDays,
  Value<int> reminderHour,
  Value<int> reminderMinute,
  Value<bool> remindersEnabled,
  Value<String> reminderTimes,
  Value<DateTime> createdAt,
  Value<DateTime?> lastCompleted,
  Value<DateTime?> lastFreezeUsed,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<int> freezeCount,
  Value<int> completedSinceFreeze,
  Value<bool> archived,
});

class $$StreaksTableTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderHour => $composableBuilder(
      column: $table.reminderHour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderMinute => $composableBuilder(
      column: $table.reminderMinute,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
      column: $table.remindersEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderTimes => $composableBuilder(
      column: $table.reminderTimes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCompleted => $composableBuilder(
      column: $table.lastCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastFreezeUsed => $composableBuilder(
      column: $table.lastFreezeUsed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get freezeCount => $composableBuilder(
      column: $table.freezeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedSinceFreeze => $composableBuilder(
      column: $table.completedSinceFreeze,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnFilters(column));
}

class $$StreaksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderHour => $composableBuilder(
      column: $table.reminderHour,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
      column: $table.reminderMinute,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
      column: $table.remindersEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderTimes => $composableBuilder(
      column: $table.reminderTimes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCompleted => $composableBuilder(
      column: $table.lastCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastFreezeUsed => $composableBuilder(
      column: $table.lastFreezeUsed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get freezeCount => $composableBuilder(
      column: $table.freezeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedSinceFreeze => $composableBuilder(
      column: $table.completedSinceFreeze,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnOrderings(column));
}

class $$StreaksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays, builder: (column) => column);

  GeneratedColumn<int> get reminderHour => $composableBuilder(
      column: $table.reminderHour, builder: (column) => column);

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
      column: $table.reminderMinute, builder: (column) => column);

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
      column: $table.remindersEnabled, builder: (column) => column);

  GeneratedColumn<String> get reminderTimes => $composableBuilder(
      column: $table.reminderTimes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompleted => $composableBuilder(
      column: $table.lastCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFreezeUsed => $composableBuilder(
      column: $table.lastFreezeUsed, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => column);

  GeneratedColumn<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => column);

  GeneratedColumn<int> get freezeCount => $composableBuilder(
      column: $table.freezeCount, builder: (column) => column);

  GeneratedColumn<int> get completedSinceFreeze => $composableBuilder(
      column: $table.completedSinceFreeze, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);
}

class $$StreaksTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StreaksTableTable,
    StreaksTableData,
    $$StreaksTableTableFilterComposer,
    $$StreaksTableTableOrderingComposer,
    $$StreaksTableTableAnnotationComposer,
    $$StreaksTableTableCreateCompanionBuilder,
    $$StreaksTableTableUpdateCompanionBuilder,
    (
      StreaksTableData,
      BaseReferences<_$AppDatabase, $StreaksTableTable, StreaksTableData>
    ),
    StreaksTableData,
    PrefetchHooks Function()> {
  $$StreaksTableTableTableManager(_$AppDatabase db, $StreaksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreaksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreaksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreaksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<String> scheduledDays = const Value.absent(),
            Value<int> reminderHour = const Value.absent(),
            Value<int> reminderMinute = const Value.absent(),
            Value<bool> remindersEnabled = const Value.absent(),
            Value<String> reminderTimes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastCompleted = const Value.absent(),
            Value<DateTime?> lastFreezeUsed = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<int> freezeCount = const Value.absent(),
            Value<int> completedSinceFreeze = const Value.absent(),
            Value<bool> archived = const Value.absent(),
          }) =>
              StreaksTableCompanion(
            id: id,
            title: title,
            description: description,
            frequency: frequency,
            scheduledDays: scheduledDays,
            reminderHour: reminderHour,
            reminderMinute: reminderMinute,
            remindersEnabled: remindersEnabled,
            reminderTimes: reminderTimes,
            createdAt: createdAt,
            lastCompleted: lastCompleted,
            lastFreezeUsed: lastFreezeUsed,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            freezeCount: freezeCount,
            completedSinceFreeze: completedSinceFreeze,
            archived: archived,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required String frequency,
            Value<String> scheduledDays = const Value.absent(),
            Value<int> reminderHour = const Value.absent(),
            Value<int> reminderMinute = const Value.absent(),
            Value<bool> remindersEnabled = const Value.absent(),
            Value<String> reminderTimes = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> lastCompleted = const Value.absent(),
            Value<DateTime?> lastFreezeUsed = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<int> freezeCount = const Value.absent(),
            Value<int> completedSinceFreeze = const Value.absent(),
            Value<bool> archived = const Value.absent(),
          }) =>
              StreaksTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            frequency: frequency,
            scheduledDays: scheduledDays,
            reminderHour: reminderHour,
            reminderMinute: reminderMinute,
            remindersEnabled: remindersEnabled,
            reminderTimes: reminderTimes,
            createdAt: createdAt,
            lastCompleted: lastCompleted,
            lastFreezeUsed: lastFreezeUsed,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            freezeCount: freezeCount,
            completedSinceFreeze: completedSinceFreeze,
            archived: archived,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StreaksTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StreaksTableTable,
    StreaksTableData,
    $$StreaksTableTableFilterComposer,
    $$StreaksTableTableOrderingComposer,
    $$StreaksTableTableAnnotationComposer,
    $$StreaksTableTableCreateCompanionBuilder,
    $$StreaksTableTableUpdateCompanionBuilder,
    (
      StreaksTableData,
      BaseReferences<_$AppDatabase, $StreaksTableTable, StreaksTableData>
    ),
    StreaksTableData,
    PrefetchHooks Function()>;
typedef $$CompletionsTableTableCreateCompanionBuilder
    = CompletionsTableCompanion Function({
  Value<int> id,
  required int streakId,
  required DateTime completedDate,
  Value<bool> usedFreeze,
});
typedef $$CompletionsTableTableUpdateCompanionBuilder
    = CompletionsTableCompanion Function({
  Value<int> id,
  Value<int> streakId,
  Value<DateTime> completedDate,
  Value<bool> usedFreeze,
});

class $$CompletionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CompletionsTableTable> {
  $$CompletionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakId => $composableBuilder(
      column: $table.streakId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedDate => $composableBuilder(
      column: $table.completedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get usedFreeze => $composableBuilder(
      column: $table.usedFreeze, builder: (column) => ColumnFilters(column));
}

class $$CompletionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletionsTableTable> {
  $$CompletionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakId => $composableBuilder(
      column: $table.streakId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedDate => $composableBuilder(
      column: $table.completedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get usedFreeze => $composableBuilder(
      column: $table.usedFreeze, builder: (column) => ColumnOrderings(column));
}

class $$CompletionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletionsTableTable> {
  $$CompletionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get streakId =>
      $composableBuilder(column: $table.streakId, builder: (column) => column);

  GeneratedColumn<DateTime> get completedDate => $composableBuilder(
      column: $table.completedDate, builder: (column) => column);

  GeneratedColumn<bool> get usedFreeze => $composableBuilder(
      column: $table.usedFreeze, builder: (column) => column);
}

class $$CompletionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompletionsTableTable,
    CompletionsTableData,
    $$CompletionsTableTableFilterComposer,
    $$CompletionsTableTableOrderingComposer,
    $$CompletionsTableTableAnnotationComposer,
    $$CompletionsTableTableCreateCompanionBuilder,
    $$CompletionsTableTableUpdateCompanionBuilder,
    (
      CompletionsTableData,
      BaseReferences<_$AppDatabase, $CompletionsTableTable,
          CompletionsTableData>
    ),
    CompletionsTableData,
    PrefetchHooks Function()> {
  $$CompletionsTableTableTableManager(
      _$AppDatabase db, $CompletionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> streakId = const Value.absent(),
            Value<DateTime> completedDate = const Value.absent(),
            Value<bool> usedFreeze = const Value.absent(),
          }) =>
              CompletionsTableCompanion(
            id: id,
            streakId: streakId,
            completedDate: completedDate,
            usedFreeze: usedFreeze,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int streakId,
            required DateTime completedDate,
            Value<bool> usedFreeze = const Value.absent(),
          }) =>
              CompletionsTableCompanion.insert(
            id: id,
            streakId: streakId,
            completedDate: completedDate,
            usedFreeze: usedFreeze,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompletionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CompletionsTableTable,
    CompletionsTableData,
    $$CompletionsTableTableFilterComposer,
    $$CompletionsTableTableOrderingComposer,
    $$CompletionsTableTableAnnotationComposer,
    $$CompletionsTableTableCreateCompanionBuilder,
    $$CompletionsTableTableUpdateCompanionBuilder,
    (
      CompletionsTableData,
      BaseReferences<_$AppDatabase, $CompletionsTableTable,
          CompletionsTableData>
    ),
    CompletionsTableData,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  Value<bool> darkMode,
  Value<bool> notificationsEnabled,
  Value<bool> hapticsEnabled,
  Value<int> rowid,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  Value<bool> darkMode,
  Value<bool> notificationsEnabled,
  Value<bool> hapticsEnabled,
  Value<int> rowid,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get darkMode => $composableBuilder(
      column: $table.darkMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get darkMode => $composableBuilder(
      column: $table.darkMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> darkMode = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            id: id,
            darkMode: darkMode,
            notificationsEnabled: notificationsEnabled,
            hapticsEnabled: hapticsEnabled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> darkMode = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            id: id,
            darkMode: darkMode,
            notificationsEnabled: notificationsEnabled,
            hapticsEnabled: hapticsEnabled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()>;
typedef $$AchievementsTableTableCreateCompanionBuilder
    = AchievementsTableCompanion Function({
  required String key,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$AchievementsTableTableUpdateCompanionBuilder
    = AchievementsTableCompanion Function({
  Value<String> key,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

class $$AchievementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$AchievementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$AchievementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$AchievementsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsTableTable,
    AchievementsTableData,
    $$AchievementsTableTableFilterComposer,
    $$AchievementsTableTableOrderingComposer,
    $$AchievementsTableTableAnnotationComposer,
    $$AchievementsTableTableCreateCompanionBuilder,
    $$AchievementsTableTableUpdateCompanionBuilder,
    (
      AchievementsTableData,
      BaseReferences<_$AppDatabase, $AchievementsTableTable,
          AchievementsTableData>
    ),
    AchievementsTableData,
    PrefetchHooks Function()> {
  $$AchievementsTableTableTableManager(
      _$AppDatabase db, $AchievementsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsTableCompanion(
            key: key,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsTableCompanion.insert(
            key: key,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementsTableTable,
    AchievementsTableData,
    $$AchievementsTableTableFilterComposer,
    $$AchievementsTableTableOrderingComposer,
    $$AchievementsTableTableAnnotationComposer,
    $$AchievementsTableTableCreateCompanionBuilder,
    $$AchievementsTableTableUpdateCompanionBuilder,
    (
      AchievementsTableData,
      BaseReferences<_$AppDatabase, $AchievementsTableTable,
          AchievementsTableData>
    ),
    AchievementsTableData,
    PrefetchHooks Function()>;
typedef $$TodosTableTableCreateCompanionBuilder = TodosTableCompanion Function({
  Value<int> id,
  required String title,
  Value<bool> isCompleted,
  Value<bool> reminderEnabled,
  Value<DateTime?> reminderAt,
  required DateTime createdAt,
});
typedef $$TodosTableTableUpdateCompanionBuilder = TodosTableCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<bool> isCompleted,
  Value<bool> reminderEnabled,
  Value<DateTime?> reminderAt,
  Value<DateTime> createdAt,
});

class $$TodosTableTableFilterComposer
    extends Composer<_$AppDatabase, $TodosTableTable> {
  $$TodosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
      column: $table.reminderAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TodosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTableTable> {
  $$TodosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
      column: $table.reminderAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TodosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTableTable> {
  $$TodosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
      column: $table.reminderAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TodosTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodosTableTable,
    TodosTableData,
    $$TodosTableTableFilterComposer,
    $$TodosTableTableOrderingComposer,
    $$TodosTableTableAnnotationComposer,
    $$TodosTableTableCreateCompanionBuilder,
    $$TodosTableTableUpdateCompanionBuilder,
    (
      TodosTableData,
      BaseReferences<_$AppDatabase, $TodosTableTable, TodosTableData>
    ),
    TodosTableData,
    PrefetchHooks Function()> {
  $$TodosTableTableTableManager(_$AppDatabase db, $TodosTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<DateTime?> reminderAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TodosTableCompanion(
            id: id,
            title: title,
            isCompleted: isCompleted,
            reminderEnabled: reminderEnabled,
            reminderAt: reminderAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<DateTime?> reminderAt = const Value.absent(),
            required DateTime createdAt,
          }) =>
              TodosTableCompanion.insert(
            id: id,
            title: title,
            isCompleted: isCompleted,
            reminderEnabled: reminderEnabled,
            reminderAt: reminderAt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodosTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodosTableTable,
    TodosTableData,
    $$TodosTableTableFilterComposer,
    $$TodosTableTableOrderingComposer,
    $$TodosTableTableAnnotationComposer,
    $$TodosTableTableCreateCompanionBuilder,
    $$TodosTableTableUpdateCompanionBuilder,
    (
      TodosTableData,
      BaseReferences<_$AppDatabase, $TodosTableTable, TodosTableData>
    ),
    TodosTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StreaksTableTableTableManager get streaksTable =>
      $$StreaksTableTableTableManager(_db, _db.streaksTable);
  $$CompletionsTableTableTableManager get completionsTable =>
      $$CompletionsTableTableTableManager(_db, _db.completionsTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$AchievementsTableTableTableManager get achievementsTable =>
      $$AchievementsTableTableTableManager(_db, _db.achievementsTable);
  $$TodosTableTableTableManager get todosTable =>
      $$TodosTableTableTableManager(_db, _db.todosTable);
}
