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

  NodeFlowDiagram({
    required this.id,
    required this.x,
    required this.y,
    required this.height,
    required this.width,
  });

  NodeFlowDiagram copyWith({
    String? id,
    double? x,
    double? y,
    double? height,
    double? width,
  }) =>
      NodeFlowDiagram(
        id: id ?? this.id,
        x: x ?? this.x,
        y: y ?? this.y,
        height: height ?? this.height,
        width: width ?? this.width,
      );

  @override
  String toString() {
    String result = 'Id=$id,x=$x,y=$y,width=$width,height=$height';
    return result;
  }
}
