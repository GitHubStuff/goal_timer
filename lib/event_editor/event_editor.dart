import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;
import 'package:popover_datetime_picker/popover_datetime_picker.dart';
import 'package:sqlite_explorer/sqlite_explorer.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:time_toggle_buttons/time_toggle_buttons.dart';

import '../constants.dart' as K;
import '../database/goal_timer_database.dart';
import '../event_editor/cubit/event_editor_cubit.dart';

class EventEditor extends StatefulWidget {
  static const String route = '/event_editor';

  final int recordId;

  EventEditor({Key? key, this.recordId = 0}) : super(key: key);

  @override
  _EventEditor createState() => _EventEditor();
}

///
class _EventEditor extends ObservingStatefulWidget<EventEditor> {
  late final TextEditingController _textEditingController;

  @override
  initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Time Editor'),
        actions: [
          ThemeControlWidget(),
        ],
      ),
      body: _sqliteExplorer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _createRecord();
        },
        tooltip: 'Add Goal',
        child: Icon(Icons.add),
      ),
    );
  }

  Future _createRecord() async {
    final toggleCubit = Modular.get<ToggleButtonsCubit>();
    final setDateTimeElements = toggleCubit.dateTimeElements();
    final displayContext = StringExtensions.composeDateTimeItems(setDateTimeElements);
    final eventEditorCubit = Modular.get<EventEditorCubit>();
    final dateTime = eventEditorCubit.startTime;
    final String title = _textEditingController.text.isEmpty ? '${DateTime.now().shortDate()} ${DateTime.now().shortTime()}?' : _textEditingController.text;
    final GoalTimesCompanion goal = GoalTimesCompanion.insert(
      title: Value(title),
      startDateTime: Value(dateTime.toIso8601String()),
      displayDateTimeElement: Value(displayContext),
    );
    final dao = Modular.get<GoalTimeDao>();
    await dao.insert(goal);
  }

  Widget _sqliteExplorer() {
    return SqliteScreenWidget(
      parentWidget: _body(),
      enabled: K.enableSqliteExplorer,
      moorBridge: Modular.get<MoorBridge>(),
      rowsPerPage: 8,
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _textField(),
        SizedBox(height: 18.0),
        _startDateField(),
        SizedBox(height: 18.0),
        //_endDateField(),
        SizedBox(height: 18.0),
        _buttons(),
      ],
    );
  }

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Event Name',
        ),
      ),
    );
  }

  Widget _startDateField() {
    String caption = 'Set Goal Date';
    return PopoverDateTimePicker(
      key: UniqueKey(),
      onWidget: Container(
        child: Center(
          child: BlocBuilder<EventEditorCubit, EventEditorState>(
            bloc: Modular.get<EventEditorCubit>(),
            builder: (context, state) {
              if (state is EventEditorDateTimeUpdate) {
                final DateTime? dateTime = state.startTime;
                caption = (dateTime == null) ? 'Set Goal Date' : '${dateTime.shortDate()} ${dateTime.shortTime()}';
              }
              return Text(
                caption,
                style: K.textStyle,
              );
            },
          ),
        ),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.circular(10)),
        height: K.fontSize * 1.50,
        width: K.buttonWidth,
      ),
      callback: (dateTime) {
        Modular.get<EventEditorCubit>().setStartTime(dateTime);
      },
    );
  }

  Widget _buttons() {
    return TimeToggleButtons();
  }
}
