import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grafcet/models/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(0)) {
    on<TimerStarted>((event, emit) {
      emit(const TimerRunInProgress(0));
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker
          .tick(
              millisecondsTickStep: event.millisecondsStep,
              currentMilliseconds: 0)
          .listen((cMilliseconds) =>
              add(TimerTicked(currentMilliseconds: cMilliseconds)));
    });

    on<TimerTicked>((event, emit) {
      emit(TimerRunInProgress(event.currentMilliseconds));
      //print('ticked')
    });

    on<TimerPaused>((event, emit) {
      if (state is TimerRunInProgress) {
        _tickerSubscription?.pause();
        emit(TimerRunInPause(event.currentMilliseconds));
      }
    });

    on<TimerResumed>((event, emit) {
      if (state is TimerRunInPause) {
        _tickerSubscription?.resume();
        emit(TimerRunInProgress(event.currentMilliseconds));
      }
    });

    on<TimerReset>((event, emit) {
      _tickerSubscription?.cancel();
      emit(const TimerInitial(0));
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
