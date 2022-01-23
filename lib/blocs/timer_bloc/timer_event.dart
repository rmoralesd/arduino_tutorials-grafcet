part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final int millisecondsStep;
  const TimerStarted({required this.millisecondsStep});
}

class TimerPaused extends TimerEvent {
  final int currentMilliseconds;
  const TimerPaused({required this.currentMilliseconds});
}

class TimerResumed extends TimerEvent {
  final int currentMilliseconds;
  const TimerResumed({required this.currentMilliseconds});
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerTicked extends TimerEvent {
  final int currentMilliseconds;

  const TimerTicked({required this.currentMilliseconds});

  @override
  List<Object> get props => [currentMilliseconds];
}
