import 'package:flutter_modular/flutter_modular.dart';
import 'package:goal_timer/event_editor/cubit/event_editor_cubit.dart';
import 'package:goal_timer/event_editor/event_editor.dart';
import 'package:time_toggle_buttons/time_toggle_buttons.dart';

import '../goal_display/goal_module.dart';
import 'scaffold_widget.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => ToggleCubit()),
    Bind.singleton((i) => EventEditorCubit()),
  ];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => ScaffoldWidget(title: 'empty_package')),
    ModuleRoute(GoalModule.route, module: GoalModule()),
    ChildRoute(EventEditor.route, child: (_, __) => EventEditor()),
  ];
}
