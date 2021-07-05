import 'package:bloc/bloc.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:meta/meta.dart';

part 'event_editor_state.dart';

class EventEditorCubit extends Cubit<EventEditorState> {
  DateTime? _startTime;
  DateTime? _endTime;

  DateTime get startTime => (_startTime ?? DateTime.now()).round();

  EventEditorCubit() : super(EventEditorInitial());

  void setStartTime(DateTime dateTime) {
    _startTime = dateTime;
    _doEmit(_startTime, _endTime);
  }

  void setEndTime(DateTime? dateTime) {
    _endTime = dateTime;
    _doEmit(_startTime, _endTime);
  }

  void _doEmit(DateTime? start, DateTime? end) {
    Future.delayed(Duration(milliseconds: 100), () {
      emit(EventEditorDateTimeUpdate(start, end));
    });
  }
}
