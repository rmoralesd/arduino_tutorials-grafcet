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
  bool condition = false;
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

  List<Offset> buildOffsets(FlowDiagram diagram, List<String> nodesId) {
    List<Offset> offsets = [];
    for (var id in nodesId) {
      var node = diagram.nodes.firstWhere((element) => element.id == id);
      offsets.add(Offset(node.x, node.y));
    }

    return offsets;
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild, condition=$condition');
    late List<String> path;
    if (!condition) {
      path = [
        "n5",
        "n2",
        "n3",
        "n4",
        "n6",
        "n7",
        "n8",
        "n9",
        "n10",
        "n11",
        "n13",
        "n17",
        "n18",
        "n19",
        "n21"
      ];
    } else {
      path = ["n5", "n2", "n3", "n4", "n6", "n7", "n8", "n9", "n19", "n21"];
    }
    final cpuIndicator = const CircularProgressIndicator();
    //print(flowChart!.nodes);
    return Scaffold(
      body: Column(
        children: [
          // ControlsBar(
          //   isPlaying: isPlaying,
          //   onPlayPause: () {
          //     isPlaying = !isPlaying;
          //     resetAnimation = false;
          //     setState(() {});
          //   },
          //   onStop: () {
          //     isPlaying = false;
          //     resetAnimation = true;
          //     setState(() {});
          //   },
          //   onGoPrevious: () => Navigator.pop(context),
          //   //OnGoNext: () => Navigator.pushReplacementNamed(context, 'screen2'),
          // ),
          _buildContent(cpuIndicator),
          MaterialButton(
            onPressed: () {
              condition = !condition;
              setState(() {});
            },
            child: const Text('Set condition'),
          )
        ],
      ),
    );
  }

  Row _buildContent(StatefulWidget cpuIndicator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Generalidades del Grafcet',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(
              height: 100,
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
                Stack(
                  children: [
                    Image.asset('assets/images/generalidades_grafcet_ard.png'),
                    cpuIndicator
                  ],
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
