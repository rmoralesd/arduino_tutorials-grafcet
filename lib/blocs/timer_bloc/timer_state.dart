part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int currentMilliseconds;

  const TimerState(this.currentMilliseconds);

  @override
  List<Object> get props => [currentMilliseconds];
}

class TimerInitial extends TimerState {
  const TimerInitial(int currentMilliseconds) : super(currentMilliseconds);
  @override
  String toString() => 'CurrentMilliseconds $currentMilliseconds}';
}

class TimerRunInPause extends TimerState {
  const TimerRunInPause(int currentMilliseconds) : super(currentMilliseconds);
  @override
  String toString() => 'CurrentMilliseconds $currentMilliseconds}';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int currentMilliseconds)
      : super(currentMilliseconds);
  @override
  String toString() => 'CurrentMilliseconds $currentMilliseconds}';
}
