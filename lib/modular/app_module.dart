import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqlite_explorer/sqlite_explorer.dart';
import 'package:time_toggle_buttons/time_toggle_buttons.dart';

import '../constants.dart' as K;
import '../database/goal_timer_database.dart' as DB;
import '../event_editor/cubit/event_editor_cubit.dart';
import '../event_editor/event_editor.dart';
import '../goal_display/goal_module.dart';
import 'scaffold_widget.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [
    Bind.factory((i) => DB.GoalTimeDao(i())),
    Bind.factory((i) => MoorBridge(dbName: K.dbName, generatedDatabase: i())),
    Bind.singleton((i) => DB.GoalTimerDatabase()),
    Bind.singleton((i) => EventEditorCubit()),
    Bind.singleton((i) => ToggleButtonsCubit()),
  ];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => ScaffoldWidget(title: 'empty_package')),
    ModuleRoute(GoalModule.route, module: GoalModule()),
    ChildRoute(EventEditor.route, child: (_, __) => EventEditor()),
  ];
}
