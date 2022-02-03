import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/models.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/models/vars.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Screen2Bloc extends StatelessWidget {
  const Screen2Bloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => TimerBloc(ticker: const Ticker()),
          )
        ],
        child: Provider<Variables>(
          create: (_) => Variables()
            ..appendVar(
                name: 'condition', currentValue: false, resetValue: false)
            ..appendVar(name: 'etapa', currentValue: 0, resetValue: 0),
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ControlsBar(
                    onGoNext: () => Navigator.pushNamed(context, 'screen2'),
                    onGoPrevious: () => Navigator.pop(context)),
                const Screen2Body(),
              ],
            ),
          ),
        ));
  }
}

class Screen2Body extends StatelessWidget {
  const Screen2Body({Key? key}) : super(key: key);

  int getNextNodeForGrafcet(Variables variables) {
    int etapa = variables.getValue('etapa');
    switch (etapa) {
      case 0:
        return 1;
      case 1:
        return 4;
    }

    return 0;
  }

  int getNextNodeForFlowDiagram(Variables variables, int currentNodeIndex) {
    int nextNodeIndex = 0;
    switch (currentNodeIndex) {
      case -1:
        nextNodeIndex = 5;
        break;
      case 5:
        nextNodeIndex = 2;
        break;
      case 2:
        nextNodeIndex = 3;
        break;
      case 3:
        nextNodeIndex = 4;
        break;
      case 4:
        nextNodeIndex = 6;
        break;
      case 6: //void Loop
        nextNodeIndex = 7;

        break;
      case 7: //Entradas
        nextNodeIndex = 8;
        break;
      case 8:
        if (variables.getValue('etapa') == 0) {
          nextNodeIndex = 9;
        } else {
          nextNodeIndex = 14;
        }
        break;
      case 9:
        nextNodeIndex = 10;
        break;
      case 10:
        nextNodeIndex = 11;
        break;
      case 11:
        if (variables.getValue('condition')) {
          nextNodeIndex = 12;
        } else {
          nextNodeIndex = 13;
        }
        break;
      case 12:
        nextNodeIndex = 20;
        break;
      case 13:
        nextNodeIndex = 19;
        break;
      case 14:
        nextNodeIndex = 15;
        break;
      case 15:
        nextNodeIndex = 19;
        break;
      case 17:
        nextNodeIndex = 18;
        break;
      case 18:
        nextNodeIndex = 19;
        break;
      case 19: //Salidas
        nextNodeIndex = 21;
        break;
      case 20: //Etapa=1
        variables.setValue('etapa', 1);
        nextNodeIndex = 13;
        break;
      case 21: //Fin
        nextNodeIndex = 6;
        break;
    }
    return nextNodeIndex;
  }

  @override
  Widget build(BuildContext context) {
    final vars = context.read<Variables>();
    final variables = context.read<Variables>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Generalidades del Grafcet',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Diagram(
              graphmlFile: 'assets/xml/generalidades_grafcet.graphml',
              getNextNodeIndex: (_) {
                return getNextNodeForGrafcet(variables);
              },
              imageFile: 'assets/images/generalidades_grafcet.png',
              imageSize: const Size(788, 540),
              cpuIndicatorType: CPUIndicatorType.robot,
              initialNodeIndex: 1,
              scale: 2.0,
            ),
            Container(
              color: Colors.black,
              width: 10,
              height: 500,
            ),
            Diagram(
              graphmlFile: 'assets/xml/generalidades_grafcet_ard.graphml',
              getNextNodeIndex: (currentNodeIndex) {
                return getNextNodeForFlowDiagram(variables, currentNodeIndex);
              },
              imageFile: 'assets/images/generalidades_grafcet_ard.png',
              imageSize: const Size(887, 781),
              cpuIndicatorType: CPUIndicatorType.arrow,
              initialNodeIndex: -1,
              scale: 1.25,
            ),
          ],
        ),
        _ButtonCondition(vars: vars)
      ],
    );
  }
}

class _ButtonCondition extends StatefulWidget {
  const _ButtonCondition({
    Key? key,
    required this.vars,
  }) : super(key: key);

  final Variables vars;

  @override
  State<_ButtonCondition> createState() => _ButtonConditionState();
}

class _ButtonConditionState extends State<_ButtonCondition> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          widget.vars.setValue('condition', !widget.vars.getValue('condition'));
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
            textStyle:
                Theme.of(context).textTheme.button!.copyWith(fontSize: 40),
            primary: widget.vars.getValue('condition')
                ? Colors.green[500]
                : Colors.red),
        child: Text('Condicion = ${widget.vars.getValue('condition')}'));
  }
}
