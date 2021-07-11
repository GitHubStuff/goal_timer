import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_intervals/date_time_intervals.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:flutter_extras/source/observing_stateful_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as FA;
import 'package:goal_timer/dropbox/cubit/dropbox_cubit.dart';
import 'package:goal_timer/dropbox/dropbox_module.dart';

import '../../constants.dart' as K;
import '../database/goal_timer_database.dart';
import '../event_editor/event_editor.dart';
import '../goal_display/cubit/goal_cubit.dart';
import '../prefs/order_by_pref.dart';
import '../widgets/popup_menu_button.dart' as W;

class GoalDisplay extends StatefulWidget {
  GoalDisplay({Key? key}) : super(key: key);

  @override
  _GoalDisplay createState() => _GoalDisplay();
}

///
class _GoalDisplay extends ObservingStatefulWidget<GoalDisplay> {
  late GoalCubit _goalCubit;

  bool _orderAscending = false;

  Size _size = Size.zero;
  String contentText = "Content of Dialog";

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🔍 AppLifecycleState ${state.toString()}');
  }

  @override
  initState() {
    super.initState();

    /// Load the sort-order from device preferences.
    OrderByPref.inOrder.then((value) {
      if (value != _orderAscending) {
        Future.delayed(Duration(microseconds: 100), () {
          setState(() {
            _orderAscending = value;
          });
        });
      }
    });
    _goalCubit = GoalCubit();
  }

  @override
  dispose() {
    _goalCubit.dispose();
    super.dispose();
  }

  Widget _orderButton() {
    final icon = FA.FaIcon(_orderAscending ? FA.FontAwesomeIcons.sortAmountDown : FA.FontAwesomeIcons.sortAmountUp);
    return IconButton(
      onPressed: () {
        setState(() {
          _orderAscending = !_orderAscending;
        });
        OrderByPref.setAscending(_orderAscending);
      },
      icon: icon,
    );
  }

  void _dropboxUpload() async {
    _goalCubit.uploadGoalsToDropbox();
    contentText = 'Building goal list';
    _show();
    final dao = Modular.get<GoalTimeDao>();
    final String? data = await dao.getJsonString();
    if (data == null) {
      Navigator.pop(context);
      _goalCubit.uploadToDropboxComplete();
      return;
    }
    setState(() {
      contentText = 'Uploading goal data';
    });
    final dropboxCubit = Modular.get<DropboxCubit>()..initDropbox();
    dropboxCubit.uploadFileWithProgress(
      data,
      fileName: '${DateTime.now().toUtc().asKey()}.json',
      progress: (up, total) {
        setState(() {
          contentText = 'Uploaded $up of $total';
        });
      },
      completed: (up, total) {
        setState(() {
          contentText = 'Upload Complete: $up of $total';
        });
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pop(context);
          _goalCubit.uploadToDropboxComplete();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Goals'),
        actions: [
          _orderButton(),
          W.popupMenuButton(context, (item) {
            switch (item) {
              case K.PopoverButtons.theme:
                break;
              case K.PopoverButtons.dropbox:
                Modular.to.pushNamed(DropboxModule.route);
                break;
              case K.PopoverButtons.upload:
                _dropboxUpload();
                break;
            }
          }),
        ],
      ),
      body: _goalWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /// 0 - is Sqlite record id that doesn't exists, so a new record is created.
          Modular.to.pushNamed(EventEditor.route, arguments: 0);
        },
        tooltip: 'Add Goal',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _goalWidget() {
    return _buildGoalList(context);
  }

  void _show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Uploading Goals to Dropbox"),
              content: Text(contentText),
            );
          },
        );
      },
    );
  }

  StreamBuilder<List<GoalTime>> _buildGoalList(BuildContext context) {
    final dao = Modular.get<GoalTimeDao>();
    return StreamBuilder(
      stream: dao.watchAllTasks(_orderAscending),
      builder: (cntx, AsyncSnapshot<List<GoalTime>> snapshot) {
        final tasks = snapshot.data ?? [];
        return ListView.builder(
          itemBuilder: (_, index) {
            final item = tasks[index];
            return _goalItem(goalTime: item, dao: dao);
          },
          itemCount: tasks.length,
        );
      },
    );
  }

  Widget _goalItem({required GoalTime goalTime, required GoalTimeDao dao}) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) => dao.deleteGoal(goalTime),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              Modular.to.pushNamed(EventEditor.route, arguments: goalTime.id);
            },
            backgroundColor: Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {},
        ),
      ),
      child: _card(goalTime: goalTime),
    );
  }

  Widget _card({required GoalTime goalTime}) {
    DateTime dt = DateTime.parse(goalTime.start).toLocal();
    String dateText = '${dt.shortDate()} ${dt.shortTime("h:mm:ss a")}';
    Set<DateTimeElement> elements = goalTime.display.elements;
    return BlocBuilder<GoalCubit, GoalState>(
        bloc: _goalCubit,
        builder: (cntx, state) {
          DateTimeIntervals dti = DateTimeIntervals.fromCurrentDateTime(eventDateTime: dt, setOfCalendarItems: elements);
          final String delta = dti.formattedString();
          CalendarDirection direction = dti.direction;
          final directionText = (direction == CalendarDirection.sinceEnd) ? 'Since' : 'Until';
          return Card(
            color: Colors.transparent,
            child: Stack(
              children: [
                _triangle(direction: direction),
                WidgetSize(
                  onChange: (newSize) {
                    /// To avoid jank only use the tallest height, the difference from tallest to smallest is left than 5pts
                    /// so there is little empty space, and empty space is perferred to constant size adjusts that make
                    /// the list appear to 'stutter'.
                    if (newSize.height > _size.height) {
                      debugPrint('NewSize index: ${goalTime.id} ${newSize.toString()}');
                      _size = Size(max(_size.width, newSize.width), max(_size.height, newSize.height));
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: K.pad,
                        child: Text(
                          goalTime.title,
                          style: K.textStyle,
                        ),
                      ),
                      Padding(
                        padding: K.pad,
                        child: AutoSizeText(
                          delta,
                          style: K.intervalStyle,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: K.pad,
                        child: Text(
                          '$directionText $dateText',
                          style: K.dateStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _triangle({required CalendarDirection direction}) {
    Color color = Colors.red.withAlpha(30);
    int opacity = 128;
    if (direction == CalendarDirection.sinceEnd) {
      color = Colors.deepPurple.withAlpha(255);
      opacity = 255;
    }
    return SizedBox(
      width: _size.width,
      height: _size.height,
      child: FloatingBubbles.alwaysRepeating(
        noOfBubbles: 10,
        colorOfBubbles: color,
        sizeFactor: 0.06,
        opacity: opacity,
        paintingStyle: PaintingStyle.stroke,
        strokeWidth: 2,
        shape: BubbleShape.circle, // circle is the default. No need to explicitly mention if its a circle.
      ),
    );
  }
}
