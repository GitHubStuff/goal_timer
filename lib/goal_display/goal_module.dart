import 'package:flutter_modular/flutter_modular.dart';
import 'package:goal_timer/dropbox/cubit/dropbox_cubit.dart';

import 'goal_display.dart';

class GoalModule extends Module {
  static const String route = '/goal_widget';

  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => DropboxCubit()),
  ];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => GoalDisplay()),
  ];
}
