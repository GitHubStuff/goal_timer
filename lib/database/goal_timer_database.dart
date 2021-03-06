import 'dart:convert';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:moor/ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_explorer/sqlite_explorer.dart';

import '../constants.dart' as K;

part 'goal_timer_database.g.dart';

///++++++++++++++++++++++++++++++++ DATABASE
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, K.dbName));
    return VmDatabase(file, logStatements: K.logSql);
  });
}

@UseMoor(tables: [GoalTimes])
class GoalTimerDatabase extends _$GoalTimerDatabase {
  GoalTimerDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}

/// This is the default, but added DataClassName for clarity
@DataClassName('GoalTime')
class GoalTimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: K.maxTitleLength).withDefault(Constant('no title'))();
  TextColumn get start => text().withLength(min: 1, max: K.maxTimeLength).withDefault(Constant('*'))();
  TextColumn get finish => text().withLength(min: 1, max: K.maxTimeLength).withDefault(Constant('*'))();
  TextColumn get display => text().withLength(min: 8, max: 8).withDefault(Constant('++++++--'))();
}

@UseDao(tables: [GoalTimes])
class GoalTimeDao extends DatabaseAccessor<GoalTimerDatabase> with _$GoalTimeDaoMixin {
  final GoalTimerDatabase db;
  GoalTimeDao(this.db) : super(db);
  Future<List<GoalTime>> getAllTasks() => select(goalTimes).get();
  Future<GoalTime> getTask(int recordId) async {
    final sql = 'SELECT * FROM goal_times WHERE id = $recordId LIMIT 1';
    final moorBridge = Modular.get<MoorBridge>();
    final List<Map<String, Object?>> result = await moorBridge.rawSql(sql);
    return GoalTime.fromJson(result[0]);
  }

  Future<String?> getJsonString() async {
    List<GoalTime> result = await getAllTasks();
    if (result.isEmpty) return null;
    String jsonString = jsonEncode(result);
    return jsonString;
  }

  Stream<List<GoalTime>> watchAllTasks(bool ascending) {
    final mode = ascending ? OrderingMode.asc : OrderingMode.desc;
    return (select(goalTimes)
          ..orderBy(([
            (t) => OrderingTerm(expression: t.start, mode: mode),
          ])))
        .watch();
  }

  Future deleteGoal(GoalTime goalTime) => delete(goalTimes).delete(goalTime);
  Future insertGoal(GoalTimesCompanion goalTimesCompanion) => into(goalTimes).insert(goalTimesCompanion);
  Future updateGoal(GoalTimesCompanion goalTimesCompanion) => update(goalTimes).replace(goalTimesCompanion);
}
