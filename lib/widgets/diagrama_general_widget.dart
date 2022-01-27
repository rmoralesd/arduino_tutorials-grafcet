import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafcet/widgets/widgets.dart';

import 'package:xml/xml.dart';

import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/flow_diagram.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';

class DiagramaGeneral extends StatefulWidget {
  const DiagramaGeneral({Key? key}) : super(key: key);

  void f() {}

  @override
  _DiagramaGeneralState createState() => _DiagramaGeneralState();
}

class _DiagramaGeneralState extends State<DiagramaGeneral> {
  FlowDiagram? flowChart;
  int currentNodeIndex = -1;
  void _loadXML() async {
    XmlDocument xmlDocument = XmlDocument.parse(
        await rootBundle.loadString('assets/xml/diagram_general.graphml'));
    flowChart = parseDiagram(xmlDocument, scale: 1.0);
    setState(() {});
  }

  @override
  void initState() {
    _loadXML();
    super.initState();
  }

  NodeFlowDiagram? getNextNode() {
    if (flowChart != null) {
      currentNodeIndex++;
      if (currentNodeIndex == flowChart!.nodes.length) {
        currentNodeIndex = 4;
      }
    }

    return flowChart?.nodes[currentNodeIndex];
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<TimerBloc>().state is TimerInitial) {
      currentNodeIndex = -1;
    }
    return BlocListener<TimerBloc, TimerState>(
      listener: (previous, current) {
        if (current is TimerInitial) {
          currentNodeIndex = -1;
          setState(() {});
        }
      },
      child: Stack(
        children: [
          Image.asset(
            'assets/images/diagrama_general.png',
          ),
          CPUIndicator(
            getNextNode: getNextNode,
          )
        ],
      ),
    );
  }
}
