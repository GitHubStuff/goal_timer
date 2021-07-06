import 'package:flutter/material.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:flutter_extras/source/observing_stateful_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:time_toggle_buttons/source/time_toggle_buttons_widget.dart';

import '../database/goal_timer_database.dart';
import '../event_editor/event_editor.dart';

class GoalDisplay extends StatefulWidget {
  GoalDisplay({Key? key}) : super(key: key);

  @override
  _GoalDisplay createState() => _GoalDisplay();
}

///
class _GoalDisplay extends ObservingStatefulWidget<GoalDisplay> {
  List<bool> _isExpanded = List.generate(0, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Timer'),
        actions: [
          ThemeControlWidget(),
        ],
      ),
      body: _buildGoalList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed(EventEditor.route, arguments: 0);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _goalWidget() {
    return SingleChildScrollView();
  }

  StreamBuilder<List<GoalTime>> _buildGoalList(BuildContext context) {
    final dao = Modular.get<GoalTimeDao>();
    return StreamBuilder(
      stream: dao.watchAllTasks(),
      builder: (cntx, AsyncSnapshot<List<GoalTime>> snapshot) {
        final tasks = snapshot.data ?? [];
        _isExpanded = List.generate(tasks.length, (_) => false);
        return ListView.builder(
          itemBuilder: (_, index) {
            final item = tasks[index];
            return _column(goalTime: item);
          },
          itemCount: tasks.length,
        );
      },
    );
  }

  List<Widget> _primative(List<GoalTime> list) {
    List<Widget> result = [];
    return result;
  }

  Widget _column({required GoalTime goalTime}) {
    DateTime dt = DateTime.parse(goalTime.start).toLocal();
    String dateText = '${dt.shortDate()} ${dt.shortTime("h:mm:ss a")}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(goalTime.title),
        Text('Duration'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Direction'), Text(dateText)],
        ),
      ],
    );
  }

  // Widget _body() {
  //   return SingleChildScrollView(
  //     child: Container(
  //         child: ExpansionPanelList(
  //       expansionCallback: (index, isExpanded) {
  //         // setState(() {
  //         //   _isExpanded[index] = !isExpanded;
  //         // });
  //       },
  //       children: [
  //         for (int i = 0; i < 5; i++)
  //           ExpansionPanel(
  //             isExpanded: _isExpanded[i],
  //             body: _card(),
  //             headerBuilder: (_, isExpanded) {
  //               return _column(goalTime: goalTime)
  //             },
  //           ),
  //       ],
  //     )),
  //   );
  // }

  /// Shown when widget is expanded
  Widget _card() {
    return Card(
        margin: EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TimeToggleButtons(),
            Text('Duration'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Direction'), Text('TS')],
            ),
          ],
        ));
  }
}
