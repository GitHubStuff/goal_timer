import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  late Timer _timer;

  GoalCubit() : super(GoalInitial()) {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      emit(GoalUpdate());
    });
  }

  void dispose() {
    _timer.cancel();
  }
}
