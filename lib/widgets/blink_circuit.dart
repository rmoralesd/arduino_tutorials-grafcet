import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/models.dart';

class BlinkCircuit extends StatelessWidget {
  final bool ledState;
  final int timeScale;
  const BlinkCircuit({
    Key? key,
    this.ledState = false,
    this.timeScale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((TimerBloc bloc) => bloc.state.currentMilliseconds);
    final led = context.read<Variables>().getValue('ledState') == 'HIGH';
    final millis =
        context.read<TimerBloc>().state.currentMilliseconds * timeScale;
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              'assets/images/circuit1/circuit.png',
              scale: 3,
            ),
            if (led)
              Positioned(
                child: Image.asset(
                  'assets/images/circuit1/diodeLedOn.png',
                  scale: 3,
                ),
                top: 0,
                left: 102,
              ),
            if (led)
              Positioned(
                child: Image.asset(
                  'assets/images/circuit1/internalLedOn.png',
                  scale: 3,
                ),
                top: 122,
                left: 105,
              )
          ],
        ),
        Text(
          'millis()=$millis',
          style: const TextStyle(fontSize: 28),
        )
      ],
    );
  }
}
