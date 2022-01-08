import 'package:flutter_test/flutter_test.dart';
import 'package:grafcet/helpers.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:xml/xml.dart';

import 'fixtures/fixture_reader.dart';

void main() {
  XmlDocument testDoc = XmlDocument.parse(fixture('yed_diagram.graphml'));
  group('parseDiagram', () {
    test('parseDiagram debe retornar una instancia de FlowDiagram', () {
      var flowDiagram = parseDiagram(testDoc);
      expect(flowDiagram, isA<FlowDiagram>());
    });

    test(
        'parseDiagrama debe retornar una instancia de FlowDiagram con nueve nodos',
        () {
      var flowDiagram = parseDiagram(testDoc);
      expect(flowDiagram.nodes.length, 9);
    });
  });
}
