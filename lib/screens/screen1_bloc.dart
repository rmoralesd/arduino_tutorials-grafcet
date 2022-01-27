import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/diagrama_general_widget.dart';

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
        children: [
          ControlsBar(
            onGoNext: () => Navigator.pushNamed(context, 'screen2'),
          ),
          const Screen1Body(),
        ],
      ),
    );
  }
}

class Screen1Body extends StatelessWidget {
  const Screen1Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Esquema general de funcionamiento',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: 10,
            ),
            const DiagramaGeneral()
          ],
        )
      ],
    );
  }
}
