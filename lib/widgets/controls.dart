import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';

class ControlsBar extends StatelessWidget {
  final Function()? onGoPrevious;
  final Function()? onGoNext;
  final Function()? onStop;
  final Function()? onPlayPause;

  const ControlsBar({
    Key? key,
    this.onGoPrevious,
    this.onGoNext,
    this.onStop,
    this.onPlayPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: onGoPrevious,
                icon: const Icon(Icons.navigate_before)),
            IconButton(
                onPressed: () {
                  context.read<TimerBloc>().add(const TimerReset());
                },
                icon: const Icon(Icons.stop)),
            IconButton(
                onPressed: () {
                  if (state is TimerInitial) {
                    context
                        .read<TimerBloc>()
                        .add(const TimerStarted(millisecondsStep: 100));
                  } else if (state is TimerRunInPause) {
                    context.read<TimerBloc>().add(TimerResumed(
                        currentMilliseconds: state.currentMilliseconds));
                  } else if (state is TimerRunInProgress) {
                    context.read<TimerBloc>().add(TimerPaused(
                        currentMilliseconds: state.currentMilliseconds));
                  }
                },
                icon: (state is! TimerRunInProgress)
                    ? const Icon(Icons.play_arrow)
                    : const Icon(Icons.pause)
                //: const Icon(Icons.play_arrow),
                ),
            IconButton(
                onPressed: onGoNext,
                icon: const Icon(Icons.navigate_next_outlined)),
          ],
        );
      },
    );
  }
}
