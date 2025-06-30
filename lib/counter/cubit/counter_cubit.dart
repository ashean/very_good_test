import 'package:bloc/bloc.dart';

import 'package:my_app/core/logging/app_logger.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    AppLogger.logInfo('Counter incremented', 'CounterCubit');
    emit(state + 1);
  }

  void decrement() {
    AppLogger.logInfo('Counter decremented', 'CounterCubit');
    emit(state - 1);
  }

  void reset() {
    AppLogger.logInfo('Counter reset', 'CounterCubit');
    emit(0);
  }
}
