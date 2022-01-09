import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:grafcet/widgets/widgets.dart';
import 'package:xml/xml.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  FlowDiagram? flowChart;
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
    //print(flowChart!.nodes);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.navigate_before)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.navigate_next_outlined)),
        ],
      ),
      body: Row(
        children: [
          const SizedBox(
            width: 50,
          ),
          Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/diagrama_general.png',
                  ),
                  flowChart != null
                      ? CpuIndicator(
                          path: flowChart!.nodes
                              .map((e) => Offset(e.x, e.y))
                              .toList(),
                        )
                      : const CircularProgressIndicator()
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
