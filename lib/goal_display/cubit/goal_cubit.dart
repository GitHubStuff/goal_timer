import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  late Timer _timer;
  bool _paused = false;

  GoalCubit() : super(GoalInitial()) {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!_paused) emit(GoalUpdate());
    });
  }

  void setPause(bool flag) {
    Future.delayed(Duration(milliseconds: 100), () {
      _paused = flag;
    });
  }

  void dispose() {
    _timer.cancel();
  }

  void uploadGoalsToDropbox() async {
    /// let one more cycle run;
    Future.delayed(Duration(milliseconds: 505), () {
      _paused = true;
    });
  }

  void uploadToDropboxComplete() async {
    /// let one more cycle run;
    Future.delayed(Duration(milliseconds: 250), () {
      _paused = false;
    });
  }
}
