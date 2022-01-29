import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/models.dart';
import 'package:grafcet/widgets/widgets.dart';
import 'package:xml/xml.dart';

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
