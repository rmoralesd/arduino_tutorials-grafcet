import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/widgets/widgets.dart';

class Screen3 extends StatelessWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerBloc(ticker: const Ticker()),
        )
      ],
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Text(
              'Blink led con Grafcet',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              'Primera solución',
              style: Theme.of(context).textTheme.headline2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const _BlinkCircuit(
                  ledState: true,
                ),
                Diagram(
                  graphmlFile: 'assets/xml/circuit1/grafcet1.graphml',
                  getNextNodeIndex: (_) {
                    return 0;
                  },
                  imageFile: 'assets/images/circuit1/grafcet1.png',
                  imageSize: const Size(387, 501),
                  cpuIndicatorType: CPUIndicatorType.robot,
                  scale: 1.25,
                ),
                Diagram(
                  graphmlFile: 'assets/xml/circuit1/flowChart.graphml',
                  getNextNodeIndex: (_) {
                    return 0;
                  },
                  imageFile: 'assets/images/circuit1/flowChart.png',
                  imageSize: const Size(996, 717),
                  cpuIndicatorType: CPUIndicatorType.arrow,
                  scale: 1.25,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _BlinkCircuit extends StatelessWidget {
  final bool ledState;
  const _BlinkCircuit({
    Key? key,
    this.ledState = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/circuit1/circuit.png',
          scale: 3,
        ),
        if (ledState)
          Positioned(
            child: Image.asset(
              'assets/images/circuit1/diodeLedOn.png',
              scale: 3,
            ),
            top: 0,
            left: 102,
          ),
        if (ledState)
          Positioned(
            child: Image.asset(
              'assets/images/circuit1/internalLedOn.png',
              scale: 3,
            ),
            top: 122,
            left: 105,
          )
      ],
    );
  }
}
