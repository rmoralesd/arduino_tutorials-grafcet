import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/models.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/widgets.dart';
import 'package:provider/provider.dart';

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
                onGoNext: () => Navigator.pushNamed(context, 'screen4'),
                onGoPrevious: () => Navigator.pop(context),
              ),
              const _Screen3Body()
            ],
          ),
        ),
      ),
    );
  }
}

class _Screen3Body extends StatelessWidget {
  const _Screen3Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const timeScale = 21;
    return Column(
      children: [
        Text(
          'Blink led con Grafcet',
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          'Primera soluci??n',
          style: Theme.of(context).textTheme.headline2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                BlinkCircuit(
                  ledState:
                      context.read<Variables>().getValue('ledState') == 'HIGH',
                  timeScale: timeScale,
                ),
                //const _VarsTable(),
                const VarsTable()
              ],
            ),
            Diagram(
              graphmlFile: 'assets/xml/circuit1/grafcet1.graphml',
              getNextNodeIndex: (_) {
                final etapa = context.read<Variables>().getValue('etapa');
                switch (etapa) {
                  case 0:
                    return 0;
                  case 1:
                    return 2;
                  case 2:
                    return 5;
                  case 3:
                    return 10;
                }
                return 0;
              },
              imageFile: 'assets/images/circuit1/grafcet1.png',
              imageSize: const Size(387, 501),
              cpuIndicatorType: CPUIndicatorType.robot,
              scale: 1.25,
            ),
            Diagram(
              graphmlFile: 'assets/xml/circuit1/flowChart.graphml',
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
                  case 6:
                    return 3;
                  case 3:
                    return 4;
                  case 4:
                    return 5;
                  case 5:
                    if (vars.getValue('etapa') == 0) return 7;
                    if (vars.getValue('etapa') == 1) return 10;
                    if (vars.getValue('etapa') == 2) return 15;
                    if (vars.getValue('etapa') == 3) return 18;
                    return 0;
                  case 7:
                    return 8;
                  case 8:
                    vars.setValue('ledState', 'HIGH');
                    vars.setValue(
                        'tInicio',
                        timeScale *
                            context
                                .read<TimerBloc>()
                                .state
                                .currentMilliseconds);

                    return 9;
                  case 9:
                    vars.setValue('etapa', 1);
                    return 26;
                  case 10:
                    return 11;
                  case 11:
                    vars.setValue(
                        'tiempo',
                        timeScale *
                                context
                                    .read<TimerBloc>()
                                    .state
                                    .currentMilliseconds -
                            vars.getValue('tInicio'));

                    return 12;
                  case 12:
                    //print(vars.getValue('tiempo'));
                    if (vars.getValue('tiempo') >= 1000) {
                      return 14;
                    } else {
                      return 13;
                    }
                  case 13:
                    return 26;
                  case 14:
                    vars.setValue('etapa', 2);
                    return 13;
                  case 15:
                    return 16;
                  case 16:
                    vars.setValue('ledState', 'LOW');
                    vars.setValue(
                        'tInicio',
                        timeScale *
                            context
                                .read<TimerBloc>()
                                .state
                                .currentMilliseconds);
                    return 17;
                  case 17:
                    vars.setValue('etapa', 3);
                    return 26;
                  case 18:
                    return 19;
                  case 19:
                    vars.setValue(
                        'tiempo',
                        timeScale *
                                context
                                    .read<TimerBloc>()
                                    .state
                                    .currentMilliseconds -
                            vars.getValue('tInicio'));

                    return 20;
                  case 20:
                    //print(vars.getValue('tiempo'));
                    if (vars.getValue('tiempo') >= 1000) {
                      return 22;
                    } else {
                      return 21;
                    }
                  case 21:
                    return 26;
                  case 22:
                    vars.setValue('etapa', 0);
                    return 21;

                  case 26:
                    return 23;
                  case 23:
                    return 24;
                  case 24:
                    return 4;

                  default:
                    return 0;
                }
              },
              imageFile: 'assets/images/circuit1/flowChart.png',
              imageSize: const Size(996, 717),
              cpuIndicatorType: CPUIndicatorType.arrow,
              initialNodeIndex: -1,
              scale: 1.25,
            ),
          ],
        )
      ],
    );
  }
}
