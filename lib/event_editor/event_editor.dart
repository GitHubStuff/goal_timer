import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:goal_timer/constants.dart' as K;
import 'package:goal_timer/event_editor/cubit/event_editor_cubit.dart';
import 'package:popover_datetime_picker/popover_datetime_picker.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:time_toggle_buttons/time_toggle_buttons.dart';

class EventEditor extends StatefulWidget {
  static const String route = '/event_editor';

  EventEditor({Key? key}) : super(key: key);

  @override
  _EventEditor createState() => _EventEditor();
}

///
class _EventEditor extends ObservingStatefulWidget<EventEditor> {
  late final TextEditingController _controller;

  @override
  initState() {
    super.initState();
    _controller = TextEditingController();
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
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pop();
        },
        tooltip: 'Add Event',
        child: Icon(Icons.add),
      ),
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
        controller: _controller,
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
        width: K.buttonWidth,
        height: K.fontSize * 1.50,
        color: Colors.blueAccent,
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
      ),
      callback: (dateTime) {
        Modular.get<EventEditorCubit>().setStartTime(dateTime);
      },
    );
  }

  Widget _endDateField() {
    String caption = '[optional End Date]';
    return PopoverDateTimePicker(
      key: UniqueKey(),
      onWidget: Container(
        width: K.buttonWidth,
        height: K.fontSize * 1.50,
        color: Colors.blueAccent,
        child: Center(
          child: BlocBuilder<EventEditorCubit, EventEditorState>(
            bloc: Modular.get<EventEditorCubit>(),
            builder: (context, state) {
              if (state is EventEditorDateTimeUpdate) {
                final DateTime? dateTime = state.endTime;
                caption = (dateTime == null) ? '[optional End Date]' : '${dateTime.shortDate()} ${dateTime.shortTime()}';
              }
              return Text(
                caption,
                style: K.textStyle,
              );
            },
          ),
        ),
      ),
      callback: (dateTime) {
        Modular.get<EventEditorCubit>().setEndTime(dateTime);
      },
    );
  }

  Widget _buttons() {
    return TimeToggleButtons();
  }
}
