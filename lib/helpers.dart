import 'package:xml/xml.dart';
import 'package:grafcet/models/flow_diagram.dart';

FlowDiagram parseDiagram(XmlDocument document) {
  var nodes = _readNodes(document);
  var minX =
      nodes.reduce((value, element) => value.x < element.x ? value : element).x;
  var minY =
      nodes.reduce((value, element) => value.y < element.y ? value : element).y;

  var newNodes =
      nodes.map((e) => e.copyWith(x: e.x - minX, y: e.y - minY)).toList();

  var flowDiagrama = FlowDiagram(nodes: newNodes);

  return flowDiagrama;
}

List<NodeFlowDiagram> _readNodes(XmlDocument document) {
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

    nodes.add(NodeFlowDiagram(
      id: id,
      x: x,
      y: y,
      height: height,
      width: width,
    ));
  }
  return nodes;
}
