import 'package:flutter/material.dart';
import 'package:flutter_extras/source/observing_stateful_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:goal_timer/event_editor/event_editor.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:time_toggle_buttons/source/time_toggle_buttons_widget.dart';

const int count = 20;

class GoalDisplay extends StatefulWidget {
  GoalDisplay({Key? key}) : super(key: key);

  @override
  _GoalDisplay createState() => _GoalDisplay();
}

///
class _GoalDisplay extends ObservingStatefulWidget<GoalDisplay> {
  List<bool> _isExpanded = List.generate(count, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Timer'),
        actions: [
          ThemeControlWidget(),
        ],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed(EventEditor.route);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
          child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          // setState(() {
          //   _isExpanded[index] = !isExpanded;
          // });
        },
        children: [
          for (int i = 0; i < count; i++)
            ExpansionPanel(
              isExpanded: _isExpanded[i],
              body: _card(),
              headerBuilder: (_, isExpanded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title'),
                    Text('Duration'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Direction'), Text('TimeStamp')],
                    ),
                  ],
                );
              },
            ),
        ],
      )),
    );
  }

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
