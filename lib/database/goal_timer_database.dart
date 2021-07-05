import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  TextColumn get startDateTime => text().withLength(min: 1, max: K.maxTimeLength).withDefault(Constant('*'))();
  TextColumn get finishDateTime => text().withLength(min: 1, max: K.maxTimeLength).withDefault(Constant('*'))();
  TextColumn get displayDateTimeElement => text().withLength(min: 8, max: 8).withDefault(Constant('++++++--'))();
}

@UseDao(tables: [GoalTimes])
class GoalTimeDao extends DatabaseAccessor<GoalTimerDatabase> with _$GoalTimeDaoMixin {
  final GoalTimerDatabase db;
  GoalTimeDao(this.db) : super(db);
  Future<List<GoalTime>> getAllTasks() => select(goalTimes).get();
  Stream<List<GoalTime>> watchAllTasks() => select(goalTimes).watch();
  Future insert(GoalTimesCompanion goalTimesCompanion) => into(goalTimes).insert(goalTimesCompanion);
}
