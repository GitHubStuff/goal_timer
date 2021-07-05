part of 'event_editor_cubit.dart';

@immutable
abstract class EventEditorState {}

class EventEditorInitial extends EventEditorState {}

class EventEditorDateTimeUpdate extends EventEditorState {
  final DateTime? startTime;
  final DateTime? endTime;
  EventEditorDateTimeUpdate(this.startTime, this.endTime);
}
