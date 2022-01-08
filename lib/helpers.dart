import 'package:xml/xml.dart';
import 'package:grafcet/models/flow_diagram.dart';

FlowDiagram parseDiagram(XmlDocument document) {
  List<NodeFlowDiagram> nodes = [];
  for (var node in document.findAllElements('node')) {
    var id = node.attributes.single.value;
    var height = double.parse(
        node.children[1].children[1].children[1].attributes[0].value);
    var width = double.parse(
        node.children[1].children[1].children[1].attributes[1].value);
    var x = double.parse(
        node.children[1].children[1].children[1].attributes[2].value);
    var y = double.parse(
        node.children[1].children[1].children[1].attributes[3].value);

    nodes.add(NodeFlowDiagram(id, x, y, height, width));
  }

  var flowDiagrama = FlowDiagram(nodes: nodes);

  return flowDiagrama;
}
