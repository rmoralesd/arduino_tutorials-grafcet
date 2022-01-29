import 'package:flutter/material.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';

enum CPUIndicatorType { arrow, robot }

class CPUIndicator extends StatefulWidget {
  final NodeFlowDiagram? Function() getNextNode;
  final CPUIndicatorType cpuIndicatorType;
  final double width;
  final double height;
  final bool resetPath;

  const CPUIndicator({
    Key? key,
    required this.getNextNode,
    this.cpuIndicatorType = CPUIndicatorType.arrow,
    this.width = 100.0,
    this.height = 100.0,
    this.resetPath = false,
  }) : super(key: key);

  @override
  State<CPUIndicator> createState() => CPUIndicatorState();
}

class CPUIndicatorState extends State<CPUIndicator> {
  final List<Offset> points = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.select((TimerBloc bloc) => bloc.state.currentMilliseconds);
    final node = widget.getNextNode();

    if (node == null) {
      return const CircularProgressIndicator();
    }
    final offsetX =
        (widget.cpuIndicatorType == CPUIndicatorType.arrow) ? 25 : 50;
    if (widget.resetPath) {
      points.clear();
    } else {
      points
          .add(Offset(node.x + node.width / 2, node.y + node.height / 2 + 12));
      if (points.length > 4) points.removeAt(0);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          CustomPaint(painter: PathPainter(points)),
          Positioned(
            top: node.y,
            left: node.x - offsetX,
            child: (widget.cpuIndicatorType == CPUIndicatorType.arrow)
                ? Image.asset(
                    'assets/images/arrow.gif',
                    width: 50,
                    height: 50,
                  )
                : Image.asset(
                    'assets/images/robot-idle.gif',
                    width: 75,
                    height: 75,
                  ),
          ),
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> points;

  PathPainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(100, 0, 255, 0)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    if (points.length >= 2) {
      canvas.drawLine(points[0], points[1], paint);
    }
    if (points.length >= 3) {
      canvas.drawLine(points[1], points[2], paint);
    }
    if (points.length >= 4) {
      canvas.drawLine(points[2], points[3], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
