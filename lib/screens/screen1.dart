import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/widgets.dart';
import 'package:xml/xml.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  FlowDiagram? flowChart;
  bool isPlaying = false;
  bool resetAnimation = false;
  void _loadXML() async {
    XmlDocument xmlDocument = XmlDocument.parse(
        await rootBundle.loadString('assets/xml/diagram_general.graphml'));
    flowChart = parseDiagram(xmlDocument);
    setState(() {});
  }

  @override
  void initState() {
    _loadXML();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ControlsBar(
            isPlaying: isPlaying,
            OnPlayPause: () {
              isPlaying = !isPlaying;
              resetAnimation = false;
              setState(() {});
            },
            OnStop: () {
              isPlaying = false;
              resetAnimation = true;
              setState(() {});
            },
            OnGoNext: () => Navigator.pushNamed(context, 'screen2'),
          ),

          //_BuildContent(cpuIndicator: cpuIndicator),
        ],
      ),
    );
  }
}
