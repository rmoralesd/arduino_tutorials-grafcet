class FlowDiagram {
  final List<NodeFlowDiagram> nodes;
  FlowDiagram({
    required this.nodes,
  });
}

class NodeFlowDiagram {
  final String id;
  final double x;
  final double y;
  final double height;
  final double width;

  NodeFlowDiagram(this.id, this.x, this.y, this.height, this.width);
}
