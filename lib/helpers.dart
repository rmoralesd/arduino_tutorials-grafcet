import 'package:xml/xml.dart';
import 'package:grafcet/models/flow_diagram.dart';

FlowDiagram parseDiagram(XmlDocument document, {double scale = 1.0}) {
  var nodes = _readNodes(document, scale);
  var minX =
      nodes.reduce((value, element) => value.x < element.x ? value : element).x;
  var minY =
      nodes.reduce((value, element) => value.y < element.y ? value : element).y;

  var newNodes =
      nodes.map((e) => e.copyWith(x: e.x - minX, y: e.y - minY)).toList();

  var flowDiagrama = FlowDiagram(nodes: newNodes);

  return flowDiagrama;
}

List<NodeFlowDiagram> _readNodes(XmlDocument document, scale) {
  List<NodeFlowDiagram> nodes = [];
  for (var node in document.findAllElements('node')) {
    var id = node.attributes.single.value;
    int indexDataKey = 1;
    var dataKeyChild = node.children[indexDataKey];
    while (dataKeyChild.children.isEmpty) {
      indexDataKey++;
      dataKeyChild = node.children[indexDataKey];
    }
    var geometryChild = dataKeyChild.children[1].children[1];

    var height = double.parse(geometryChild.attributes[0].value) * scale;
    var width = double.parse(geometryChild.attributes[1].value) * scale;
    var x = double.parse(geometryChild.attributes[2].value) * scale;
    var y = double.parse(geometryChild.attributes[3].value) * scale;

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
