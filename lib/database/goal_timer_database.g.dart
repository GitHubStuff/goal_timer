// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_timer_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class GoalTime extends DataClass implements Insertable<GoalTime> {
  final int id;
  final String title;
  final String startDateTime;
  final String finishDateTime;
  final String displayDateTimeElement;
  GoalTime(
      {required this.id,
      required this.title,
      required this.startDateTime,
      required this.finishDateTime,
      required this.displayDateTimeElement});
  factory GoalTime.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return GoalTime(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      startDateTime: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start_date_time'])!,
      finishDateTime: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}finish_date_time'])!,
      displayDateTimeElement: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}display_date_time_element'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['start_date_time'] = Variable<String>(startDateTime);
    map['finish_date_time'] = Variable<String>(finishDateTime);
    map['display_date_time_element'] = Variable<String>(displayDateTimeElement);
    return map;
  }

  GoalTimesCompanion toCompanion(bool nullToAbsent) {
    return GoalTimesCompanion(
      id: Value(id),
      title: Value(title),
      startDateTime: Value(startDateTime),
      finishDateTime: Value(finishDateTime),
      displayDateTimeElement: Value(displayDateTimeElement),
    );
  }

  factory GoalTime.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GoalTime(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startDateTime: serializer.fromJson<String>(json['startDateTime']),
      finishDateTime: serializer.fromJson<String>(json['finishDateTime']),
      displayDateTimeElement:
          serializer.fromJson<String>(json['displayDateTimeElement']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startDateTime': serializer.toJson<String>(startDateTime),
      'finishDateTime': serializer.toJson<String>(finishDateTime),
      'displayDateTimeElement':
          serializer.toJson<String>(displayDateTimeElement),
    };
  }

  GoalTime copyWith(
          {int? id,
          String? title,
          String? startDateTime,
          String? finishDateTime,
          String? displayDateTimeElement}) =>
      GoalTime(
        id: id ?? this.id,
        title: title ?? this.title,
        startDateTime: startDateTime ?? this.startDateTime,
        finishDateTime: finishDateTime ?? this.finishDateTime,
        displayDateTimeElement:
            displayDateTimeElement ?? this.displayDateTimeElement,
      );
  @override
  String toString() {
    return (StringBuffer('GoalTime(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('finishDateTime: $finishDateTime, ')
          ..write('displayDateTimeElement: $displayDateTimeElement')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              startDateTime.hashCode,
              $mrjc(
                  finishDateTime.hashCode, displayDateTimeElement.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalTime &&
          other.id == this.id &&
          other.title == this.title &&
          other.startDateTime == this.startDateTime &&
          other.finishDateTime == this.finishDateTime &&
          other.displayDateTimeElement == this.displayDateTimeElement);
}

class GoalTimesCompanion extends UpdateCompanion<GoalTime> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> startDateTime;
  final Value<String> finishDateTime;
  final Value<String> displayDateTimeElement;
  const GoalTimesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.finishDateTime = const Value.absent(),
    this.displayDateTimeElement = const Value.absent(),
  });
  GoalTimesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.finishDateTime = const Value.absent(),
    this.displayDateTimeElement = const Value.absent(),
  });
  static Insertable<GoalTime> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? startDateTime,
    Expression<String>? finishDateTime,
    Expression<String>? displayDateTimeElement,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (finishDateTime != null) 'finish_date_time': finishDateTime,
      if (displayDateTimeElement != null)
        'display_date_time_element': displayDateTimeElement,
    });
  }

  GoalTimesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? startDateTime,
      Value<String>? finishDateTime,
      Value<String>? displayDateTimeElement}) {
    return GoalTimesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startDateTime: startDateTime ?? this.startDateTime,
      finishDateTime: finishDateTime ?? this.finishDateTime,
      displayDateTimeElement:
          displayDateTimeElement ?? this.displayDateTimeElement,
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
    if (startDateTime.present) {
      map['start_date_time'] = Variable<String>(startDateTime.value);
    }
    if (finishDateTime.present) {
      map['finish_date_time'] = Variable<String>(finishDateTime.value);
    }
    if (displayDateTimeElement.present) {
      map['display_date_time_element'] =
          Variable<String>(displayDateTimeElement.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalTimesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('finishDateTime: $finishDateTime, ')
          ..write('displayDateTimeElement: $displayDateTimeElement')
          ..write(')'))
        .toString();
  }
}

class $GoalTimesTable extends GoalTimes
    with TableInfo<$GoalTimesTable, GoalTime> {
  final GeneratedDatabase _db;
  final String? _alias;
  $GoalTimesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title =
      GeneratedColumn<String?>('title', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: Constant('no title'));
  final VerificationMeta _startDateTimeMeta =
      const VerificationMeta('startDateTime');
  late final GeneratedColumn<String?> startDateTime =
      GeneratedColumn<String?>('start_date_time', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: Constant('*'));
  final VerificationMeta _finishDateTimeMeta =
      const VerificationMeta('finishDateTime');
  late final GeneratedColumn<String?> finishDateTime =
      GeneratedColumn<String?>('finish_date_time', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: Constant('*'));
  final VerificationMeta _displayDateTimeElementMeta =
      const VerificationMeta('displayDateTimeElement');
  late final GeneratedColumn<String?> displayDateTimeElement =
      GeneratedColumn<String?>('display_date_time_element', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 8, maxTextLength: 8),
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: Constant('++++++--'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, startDateTime, finishDateTime, displayDateTimeElement];
  @override
  String get aliasedName => _alias ?? 'goal_times';
  @override
  String get actualTableName => 'goal_times';
  @override
  VerificationContext validateIntegrity(Insertable<GoalTime> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
          _startDateTimeMeta,
          startDateTime.isAcceptableOrUnknown(
              data['start_date_time']!, _startDateTimeMeta));
    }
    if (data.containsKey('finish_date_time')) {
      context.handle(
          _finishDateTimeMeta,
          finishDateTime.isAcceptableOrUnknown(
              data['finish_date_time']!, _finishDateTimeMeta));
    }
    if (data.containsKey('display_date_time_element')) {
      context.handle(
          _displayDateTimeElementMeta,
          displayDateTimeElement.isAcceptableOrUnknown(
              data['display_date_time_element']!, _displayDateTimeElementMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    return GoalTime.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GoalTimesTable createAlias(String alias) {
    return $GoalTimesTable(_db, alias);
  }
}

abstract class _$GoalTimerDatabase extends GeneratedDatabase {
  _$GoalTimerDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  late final $GoalTimesTable goalTimes = $GoalTimesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [goalTimes];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$GoalTimeDaoMixin on DatabaseAccessor<GoalTimerDatabase> {
  $GoalTimesTable get goalTimes => attachedDatabase.goalTimes;
}
