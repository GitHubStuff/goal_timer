// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_timer_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class GoalTime extends DataClass implements Insertable<GoalTime> {
  final int id;
  final String title;
  final String start;
  final String finish;
  final String display;
  GoalTime(
      {required this.id,
      required this.title,
      required this.start,
      required this.finish,
      required this.display});
  factory GoalTime.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return GoalTime(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      start: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start'])!,
      finish: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}finish'])!,
      display: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}display'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['start'] = Variable<String>(start);
    map['finish'] = Variable<String>(finish);
    map['display'] = Variable<String>(display);
    return map;
  }

  GoalTimesCompanion toCompanion(bool nullToAbsent) {
    return GoalTimesCompanion(
      id: Value(id),
      title: Value(title),
      start: Value(start),
      finish: Value(finish),
      display: Value(display),
    );
  }

  factory GoalTime.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GoalTime(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      start: serializer.fromJson<String>(json['start']),
      finish: serializer.fromJson<String>(json['finish']),
      display: serializer.fromJson<String>(json['display']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'start': serializer.toJson<String>(start),
      'finish': serializer.toJson<String>(finish),
      'display': serializer.toJson<String>(display),
    };
  }

  GoalTime copyWith(
          {int? id,
          String? title,
          String? start,
          String? finish,
          String? display}) =>
      GoalTime(
        id: id ?? this.id,
        title: title ?? this.title,
        start: start ?? this.start,
        finish: finish ?? this.finish,
        display: display ?? this.display,
      );
  @override
  String toString() {
    return (StringBuffer('GoalTime(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('start: $start, ')
          ..write('finish: $finish, ')
          ..write('display: $display')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(title.hashCode,
          $mrjc(start.hashCode, $mrjc(finish.hashCode, display.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalTime &&
          other.id == this.id &&
          other.title == this.title &&
          other.start == this.start &&
          other.finish == this.finish &&
          other.display == this.display);
}

class GoalTimesCompanion extends UpdateCompanion<GoalTime> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> start;
  final Value<String> finish;
  final Value<String> display;
  const GoalTimesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.start = const Value.absent(),
    this.finish = const Value.absent(),
    this.display = const Value.absent(),
  });
  GoalTimesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.start = const Value.absent(),
    this.finish = const Value.absent(),
    this.display = const Value.absent(),
  });
  static Insertable<GoalTime> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? start,
    Expression<String>? finish,
    Expression<String>? display,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (start != null) 'start': start,
      if (finish != null) 'finish': finish,
      if (display != null) 'display': display,
    });
  }

  GoalTimesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? start,
      Value<String>? finish,
      Value<String>? display}) {
    return GoalTimesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      start: start ?? this.start,
      finish: finish ?? this.finish,
      display: display ?? this.display,
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
    if (start.present) {
      map['start'] = Variable<String>(start.value);
    }
    if (finish.present) {
      map['finish'] = Variable<String>(finish.value);
    }
    if (display.present) {
      map['display'] = Variable<String>(display.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalTimesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('start: $start, ')
          ..write('finish: $finish, ')
          ..write('display: $display')
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
  final VerificationMeta _startMeta = const VerificationMeta('start');
  late final GeneratedColumn<String?> start =
      GeneratedColumn<String?>('start', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: Constant('*'));
  final VerificationMeta _finishMeta = const VerificationMeta('finish');
  late final GeneratedColumn<String?> finish =
      GeneratedColumn<String?>('finish', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: Constant('*'));
  final VerificationMeta _displayMeta = const VerificationMeta('display');
  late final GeneratedColumn<String?> display = GeneratedColumn<String?>(
      'display', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 8, maxTextLength: 8),
      typeName: 'TEXT',
      requiredDuringInsert: false,
      defaultValue: Constant('++++++--'));
  @override
  List<GeneratedColumn> get $columns => [id, title, start, finish, display];
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
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start']!, _startMeta));
    }
    if (data.containsKey('finish')) {
      context.handle(_finishMeta,
          finish.isAcceptableOrUnknown(data['finish']!, _finishMeta));
    }
    if (data.containsKey('display')) {
      context.handle(_displayMeta,
          display.isAcceptableOrUnknown(data['display']!, _displayMeta));
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
