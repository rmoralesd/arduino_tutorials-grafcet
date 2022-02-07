import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/models.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Screen4 extends StatelessWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerBloc(ticker: const Ticker()),
        )
      ],
      child: Provider<Variables>(
        create: (_) => Variables()
          ..appendVar(
              name: 'etapa', currentValue: 0, resetValue: 0, type: 'byte')
          ..appendVar(
              name: 'ledState',
              currentValue: 'LOW',
              resetValue: 'HIGH',
              type: 'int')
          ..appendVar(
              name: 'tInicio',
              currentValue: 0,
              resetValue: 0,
              type: 'unsigned long')
          ..appendVar(
              name: 'tiempo',
              currentValue: 0,
              resetValue: 0,
              type: 'unsigned long'),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              ControlsBar(
                onGoNext: () {},
                onGoPrevious: () => Navigator.pop(context),
              ),
              const _Screen4Body()
            ],
          ),
        ),
      ),
    );
  }
}

class _Screen4Body extends StatelessWidget {
  const _Screen4Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const timeScale = 21;
    return Column(
      children: [
        Text(
          'Blink led con Grafcet',
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          'Segunda solución',
          style: Theme.of(context).textTheme.headline3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                _BlinkCircuit(
                  ledState:
                      context.read<Variables>().getValue('ledState') == 'HIGH',
                  timeScale: timeScale,
                ),
                const _VarsTable(),
              ],
            ),
            Diagram(
              graphmlFile: 'assets/xml/circuit1/grafcet2.graphml',
              getNextNodeIndex: (_) {
                final etapa = context.read<Variables>().getValue('etapa');
                switch (etapa) {
                  case 0:
                    return 0;
                  case 1:
                    return 2;
                }
                return 0;
              },
              imageFile: 'assets/images/circuit1/grafcet2.png',
              imageSize: const Size(487, 284),
              cpuIndicatorType: CPUIndicatorType.robot,
              scale: 1.5,
              showNodesId: false,
            ),
            Diagram(
              graphmlFile: 'assets/xml/circuit1/flowChart2.graphml',
              getNextNodeIndex: (currentNodeIndex) {
                final vars = context.read<Variables>();

                switch (currentNodeIndex) {
                  case -1:
                    return 0;
                  case 0:
                    return 1;
                  case 1:
                    return 2;
                  case 2:
                    return 6;

                  case 3:
                    return 4;
                  case 4:
                    return 5;
                  case 5:
                    if (vars.getValue('etapa') == 0) return 7;
                    if (vars.getValue('etapa') == 1) return 17;
                    return 0;
                  case 6:
                    return 15;
                  case 7:
                    return 8;
                  case 8:
                    vars.setValue('ledState', 'HIGH');
                    vars.setValue(
                        'tiempo',
                        timeScale *
                                context
                                    .read<TimerBloc>()
                                    .state
                                    .currentMilliseconds -
                            vars.getValue('tInicio'));

                    return 9;
                  case 9:
                    if (vars.getValue('tiempo') >= 1000) {
                      return 11;
                    } else {
                      return 10;
                    }
                  case 10:
                    return 23;
                  case 11:
                    vars.setValue('etapa', 1);
                    return 16;
                  case 12:
                    return 13;

                  case 13:
                    return 4;
                  case 14:
                    return 0;
                  case 15:
                    vars.setValue(
                        'tInicio',
                        timeScale *
                            context
                                .read<TimerBloc>()
                                .state
                                .currentMilliseconds);
                    return 3;
                  case 16:
                    vars.setValue(
                        'tInicio',
                        timeScale *
                            context
                                .read<TimerBloc>()
                                .state
                                .currentMilliseconds);
                    return 10;
                  case 17:
                    return 18;
                  case 18:
                    vars.setValue('ledState', 'LOW');
                    vars.setValue(
                        'tiempo',
                        timeScale *
                                context
                                    .read<TimerBloc>()
                                    .state
                                    .currentMilliseconds -
                            vars.getValue('tInicio'));

                    return 19;
                  case 19:
                    if (vars.getValue('tiempo') >= 1000) {
                      return 21;
                    } else {
                      return 20;
                    }
                  case 20:
                    //print(vars.getValue('tiempo'));
                    return 23;
                  case 21:
                    vars.setValue('etapa', 0);
                    return 22;
                  case 22:
                    vars.setValue(
                        'tInicio',
                        timeScale *
                            context
                                .read<TimerBloc>()
                                .state
                                .currentMilliseconds);
                    return 20;

                  case 23:
                    return 12;
                  default:
                    return 0;
                }
              },
              imageFile: 'assets/images/circuit1/flowChart2.png',
              imageSize: const Size(924, 864),
              cpuIndicatorType: CPUIndicatorType.arrow,
              initialNodeIndex: -1,
              scale: 1.5,
              showNodesId: false,
            ),
          ],
        )
      ],
    );
  }
}

class _VarsTable extends StatelessWidget {
  const _VarsTable({Key? key}) : super(key: key);

  Icon getIcon(String type) {
    switch (type) {
      case 'byte':
        return const Icon(
          Icons.circle,
          size: 10,
        );
      case 'int':
        return const Icon(
          Icons.looks_one_outlined,
          size: 20,
        );
      case 'bool':
        return const Icon(Icons.check_circle);
      default:
        return const Icon(Icons.all_inclusive_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.select((TimerBloc bloc) => bloc.state.currentMilliseconds);
    final vars = context.read<Variables>();
    final List<Widget> listVars = [];
    for (var element in vars.list.keys) {
      listVars.add(ListTile(
        leading: getIcon(vars.getType(element)),
        tileColor: Colors.grey,
        title: Row(
          children: [
            Text(vars.getType(element), style: const TextStyle(fontSize: 22)),
            Text(' $element', style: const TextStyle(fontSize: 22))
          ],
        ),
        trailing: Text(vars.getValue(element).toString(),
            style: const TextStyle(fontSize: 22)),
        dense: true,
      ));
    }

    return SizedBox(
      width: 400,
      height: 200,
      child: ListView(
        children: listVars,
      ),
    );
  }
}

class _BlinkCircuit extends StatelessWidget {
  final bool ledState;
  final int timeScale;
  const _BlinkCircuit({
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
