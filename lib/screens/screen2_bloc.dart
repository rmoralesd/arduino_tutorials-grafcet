import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/models.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/models/vars.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/cpu_indicator.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

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
                ),
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
              initialNodeIndex: 5,
              scale: 1.25,
            ),
          ],
        ),
        ButtonCondition(vars: vars)
      ],
    );
  }
}

class Diagram extends StatefulWidget {
  final String graphmlFile;
  final String imageFile;
  final Size imageSize;
  final double scale;
  final int Function(int currentNodeIndex) getNextNodeIndex;
  final CPUIndicatorType cpuIndicatorType;
  final int initialNodeIndex;

  const Diagram({
    Key? key,
    required this.graphmlFile,
    this.scale = 1.0,
    required this.getNextNodeIndex,
    required this.imageFile,
    this.cpuIndicatorType = CPUIndicatorType.arrow,
    required this.imageSize,
    this.initialNodeIndex = 0,
  }) : super(key: key);

  @override
  _DiagramState createState() => _DiagramState();
}

class _DiagramState extends State<Diagram> {
  FlowDiagram? flowChart;
  late int currentNodeIndex;
  bool resetPath = false;

  _DiagramState();
  void _loadXML() async {
    XmlDocument xmlDocument =
        XmlDocument.parse(await rootBundle.loadString(widget.graphmlFile));
    flowChart = parseDiagram(xmlDocument, scale: widget.scale);
    setState(() {});
  }

  @override
  void initState() {
    _loadXML();
    currentNodeIndex = widget.initialNodeIndex;
    super.initState();
  }

  NodeFlowDiagram? getNextNode() {
    //print(widget.getNextNodeIndex());
    currentNodeIndex = widget.getNextNodeIndex(currentNodeIndex);
    return flowChart?.nodes[currentNodeIndex];
  }

  @override
  Widget build(BuildContext context) {
    final imagen = Image.asset(widget.imageFile);

    return BlocListener<TimerBloc, TimerState>(
        listener: (previous, current) {
          if (current is TimerInitial) {
            currentNodeIndex = widget.initialNodeIndex;
            resetPath = true;
            setState(() {});
            context.read<Variables>().resetVars();
          } else if (resetPath && current is TimerRunInProgress) {
            resetPath = false;
            setState(() {});
          }
        },
        child: Stack(
          children: [
            imagen,
            CPUIndicator(
              width: widget.imageSize.width,
              height: widget.imageSize.height,
              getNextNode: getNextNode,
              cpuIndicatorType: widget.cpuIndicatorType,
              resetPath: resetPath,
            )
          ],
        ));
  }
}

class ButtonCondition extends StatefulWidget {
  const ButtonCondition({
    Key? key,
    required this.vars,
  }) : super(key: key);

  final Variables vars;

  @override
  State<ButtonCondition> createState() => _ButtonConditionState();
}

class _ButtonConditionState extends State<ButtonCondition> {
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

class _DiagramaGraph extends StatefulWidget {
  const _DiagramaGraph({Key? key}) : super(key: key);

  @override
  __DiagramaGraphState createState() => __DiagramaGraphState();
}

class __DiagramaGraphState extends State<_DiagramaGraph> {
  FlowDiagram? flowChart;
  int currentNodeIndex = 1;
  bool resetPath = false;
  void _loadXML() async {
    XmlDocument xmlDocument = XmlDocument.parse(await rootBundle
        .loadString('assets/xml/generalidades_grafcet.graphml'));
    flowChart = parseDiagram(xmlDocument, scale: 2);
    setState(() {});
  }

  @override
  void initState() {
    _loadXML();
    super.initState();
  }

  NodeFlowDiagram? getNextNode() {
    switch (context.read<Variables>().getValue('etapa')) {
      case 0:
        currentNodeIndex = 1;
        break;
      case 1:
        currentNodeIndex = 4;
        break;
    }
    return flowChart?.nodes[currentNodeIndex];
  }

  @override
  Widget build(BuildContext context) {
    final imagen = Image.asset('assets/images/generalidades_grafcet.png');

    return BlocListener<TimerBloc, TimerState>(
        listener: (previous, current) {
          if (current is TimerInitial) {
            currentNodeIndex = 0;
            resetPath = true;
            setState(() {});
            context.read<Variables>().resetVars();
          } else if (resetPath && current is TimerRunInProgress) {
            resetPath = false;
            setState(() {});
          }
        },
        child: Stack(
          children: [
            imagen,
            CPUIndicator(
              width: 788,
              height: 540,
              getNextNode: getNextNode,
              cpuIndicatorType: CPUIndicatorType.robot,
              resetPath: resetPath,
            )
          ],
        ));
  }
}

class _DiagramaArd extends StatefulWidget {
  const _DiagramaArd({Key? key}) : super(key: key);

  @override
  __DiagramaArdState createState() => __DiagramaArdState();
}

class __DiagramaArdState extends State<_DiagramaArd> {
  FlowDiagram? flowChart;
  int currentNodeIndex = 5;
  bool resetPath = true;
  void _loadXML() async {
    XmlDocument xmlDocument = XmlDocument.parse(await rootBundle
        .loadString('assets/xml/generalidades_grafcet_ard.graphml'));
    flowChart = parseDiagram(xmlDocument, scale: 1.25);
    setState(() {});
  }

  @override
  void initState() {
    _loadXML();
    super.initState();
  }

  NodeFlowDiagram? getNextNode() {
    if (flowChart != null) {
      switch (currentNodeIndex) {
        case 5:
          currentNodeIndex = 2;
          break;
        case 2:
          currentNodeIndex = 3;
          break;
        case 3:
          currentNodeIndex = 4;
          break;
        case 4:
          currentNodeIndex = 6;
          break;
        case 6: //void Loop
          currentNodeIndex = 7;

          break;
        case 7: //Entradas
          currentNodeIndex = 8;
          break;
        case 8:
          if (context.read<Variables>().getValue('etapa') == 0) {
            currentNodeIndex = 9;
          } else {
            currentNodeIndex = 14;
          }
          break;
        case 9:
          currentNodeIndex = 10;
          break;
        case 10:
          currentNodeIndex = 11;
          break;
        case 11:
          if (context.read<Variables>().getValue('condition')) {
            currentNodeIndex = 12;
          } else {
            currentNodeIndex = 13;
          }
          break;
        case 12:
          currentNodeIndex = 20;
          break;
        case 13:
          currentNodeIndex = 19;
          break;
        case 14:
          currentNodeIndex = 15;
          break;
        case 15:
          currentNodeIndex = 19;
          break;
        case 17:
          currentNodeIndex = 18;
          break;
        case 18:
          currentNodeIndex = 19;
          break;
        case 19: //Salidas
          currentNodeIndex = 21;
          break;
        case 20: //Etapa=1
          context.read<Variables>().setValue('etapa', 1);
          currentNodeIndex = 13;
          break;
        case 21: //Fin
          currentNodeIndex = 6;
          break;
      }
    }

    return flowChart?.nodes[currentNodeIndex];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerBloc, TimerState>(
        listener: (previous, current) {
          if (current is TimerInitial) {
            currentNodeIndex = 5;
            resetPath = true;
            setState(() {});
            context.read<Variables>().resetVars();
          } else if (resetPath && current is TimerRunInProgress) {
            resetPath = false;
            setState(() {});
          }
        },
        child: Stack(
          children: [
            Image.asset('assets/images/generalidades_grafcet_ard.png'),
            CPUIndicator(
              width: 887,
              height: 781,
              resetPath: resetPath,
              getNextNode: getNextNode,
            )
          ],
        ));
  }
}
