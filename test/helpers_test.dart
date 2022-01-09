import 'package:flutter_test/flutter_test.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:xml/xml.dart';

import 'fixtures/fixture_reader.dart';

void main() {
  XmlDocument testDoc = XmlDocument.parse(fixture('yed_diagram.graphml'));
  late FlowDiagram flowDiagram;

  group('parseDiagram', () {
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
  });
}
