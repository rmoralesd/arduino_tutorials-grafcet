import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:grafcet/widgets/controls.dart';
import 'package:grafcet/widgets/widgets.dart';
import 'package:xml/xml.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
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
    final cpuIndicator = flowChart != null
        ? CpuIndicator(
            voidLoopIndex: 4,
            path: flowChart!.nodes.map((e) => Offset(e.x, e.y)).toList(),
            isPlaying: isPlaying,
            reset: resetAnimation,
          )
        : const CircularProgressIndicator();
    //print(flowChart!.nodes);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
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
            OnGoPrevious: () => Navigator.pop(context),
            //OnGoNext: () => Navigator.pushReplacementNamed(context, 'screen2'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Esquema general de funcionamiento',
                    style: TextStyle(fontSize: 64),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/diagrama_general.png',
                      ),
                      cpuIndicator
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
