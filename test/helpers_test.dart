import 'package:flutter_test/flutter_test.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:xml/xml.dart';

import 'fixtures/fixture_reader.dart';

void main() {
  late FlowDiagram flowDiagram;

  group('parseDiagram', () {
    XmlDocument testDoc = XmlDocument.parse(fixture('yed_diagram.graphml'));
    setUp(() {
      flowDiagram = parseDiagram(testDoc);
    });
    test('parseDiagram debe retornar una instancia de FlowDiagram', () {
      //var flowDiagram = parseDiagram(testDoc);
      expect(flowDiagram, isA<FlowDiagram>());
    });

    test(
        'parseDiagram debe retornar una instancia de FlowDiagram con nueve nodos',
        () {
      //var flowDiagram = parseDiagram(testDoc);
      expect(flowDiagram.nodes.length, 9);
    });
    test(
        'parseDiagram, al menos un nodo debe tener coordenada x=0, y al menos un nodo debe tener y=0 (no necesariamente el mismo nodo)',
        () {
      expect(flowDiagram.nodes.firstWhere((element) => element.x == 0),
          isA<NodeFlowDiagram>());
      expect(flowDiagram.nodes.firstWhere((element) => element.y == 0),
          isA<NodeFlowDiagram>());
    });

    test('parseDiagram, aplica escala a la geometria del nodo)', () {
      var scale = 2.0;
      var flowDiagram2 = parseDiagram(testDoc, scale: scale);
      bool isDouble = true;
      for (var item in flowDiagram.nodes) {
        var xisequal = (item.x * scale) ==
            flowDiagram2.nodes.firstWhere((element) => element.id == item.id).x;
        var yisequal = item.y * scale ==
            flowDiagram2.nodes.firstWhere((element) => element.id == item.id).y;
        var heightisequal = item.height * scale ==
            flowDiagram2.nodes
                .firstWhere((element) => element.id == item.id)
                .height;
        var widthisequal = item.width * scale ==
            flowDiagram2.nodes
                .firstWhere((element) => element.id == item.id)
                .width;
        if (!xisequal || !yisequal || !heightisequal || !widthisequal) {
          isDouble = false;
          break;
        }
      }
      expect(isDouble, true);
    });
  });

  group('parseDiagram con doble data key en los nodos', () {
    XmlDocument testDoc =
        XmlDocument.parse(fixture('yed_diagram_doble_data_node.graphml'));
    setUp(() {
      flowDiagram = parseDiagram(testDoc);
    });
    test('parseDiagram debe retornar una instancia de FlowDiagram', () {
      //var flowDiagram = parseDiagram(testDoc);
      expect(flowDiagram, isA<FlowDiagram>());
    });

    test(
        'parseDiagram debe retornar una instancia de FlowDiagram con veintidos nodos',
        () {
      //var flowDiagram = parseDiagram(testDoc);
      expect(flowDiagram.nodes.length, 22);
    });
    test(
        'parseDiagram, al menos un nodo debe tener coordenada x=0, y al menos un nodo debe tener y=0 (no necesariamente el mismo nodo)',
        () {
      expect(flowDiagram.nodes.firstWhere((element) => element.x == 0),
          isA<NodeFlowDiagram>());
      expect(flowDiagram.nodes.firstWhere((element) => element.y == 0),
          isA<NodeFlowDiagram>());
    });
  });
}
