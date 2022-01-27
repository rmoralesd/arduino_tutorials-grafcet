import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/models.dart';
import 'package:grafcet/models/ticker.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/cpu_indicator.dart';
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
    );
  }
}

class Screen2Body extends StatelessWidget {
  const Screen2Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Image.asset(
              'assets/images/generalidades_grafcet.png',
            ),
            Container(
              color: Colors.black,
              width: 10,
              height: 500,
            ),
            const _DiagramaArd()
          ],
        )
      ],
    );
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
        case 6:
          currentNodeIndex = 7;
          break;
        case 7:
          currentNodeIndex = 8;
          break;
        case 8:
          currentNodeIndex = 9;
          break;
        case 9:
          currentNodeIndex = 10;
          break;
        case 10:
          currentNodeIndex = 11;
          break;
        case 11:
          currentNodeIndex = 13;
          break;
        case 13:
          currentNodeIndex = 19;
          break;
        case 17:
          currentNodeIndex = 18;
          break;
        case 18:
          currentNodeIndex = 19;
          break;
        case 19:
          currentNodeIndex = 21;
          break;
        case 21:
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
            currentNodeIndex = -1;
            setState(() {});
          }
        },
        child: Stack(
          children: [
            Image.asset('assets/images/generalidades_grafcet_ard.png'),
            CPUIndicator(
              getNextNode: getNextNode,
            )
          ],
        ));
  }
}
