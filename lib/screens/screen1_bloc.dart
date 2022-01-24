import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/widgets/controls.dart';

class Screen1Bloc extends StatelessWidget {
  const Screen1Bloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const Screen1Content(),
    );
  }
}

class Screen1Content extends StatelessWidget {
  const Screen1Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Actions(),
          Screen1Body(),
        ],
      ),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (state is TimerInitial) ...[
              FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () => context
                      .read<TimerBloc>()
                      .add(const TimerStarted(millisecondsStep: 10)))
            ]
          ],
        );
      },
    );
  }
}

class Screen1Body extends StatelessWidget {
  const Screen1Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentMillis =
        context.select((TimerBloc bloc) => bloc.state.currentMilliseconds);
    return Text(currentMillis.toString());
  }
}
