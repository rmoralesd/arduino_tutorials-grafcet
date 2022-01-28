import 'package:flutter/material.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';

enum CPUIndicatorType { arrow, robot }

class CPUIndicator extends StatefulWidget {
  final NodeFlowDiagram? Function() getNextNode;
  final CPUIndicatorType cpuIndicatorType;
  const CPUIndicator({
    Key? key,
    required this.getNextNode,
    this.cpuIndicatorType = CPUIndicatorType.arrow,
  }) : super(key: key);

  @override
  State<CPUIndicator> createState() => CPUIndicatorState();
}

class CPUIndicatorState extends State<CPUIndicator> {
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

    return Positioned(
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
    );
  }
}
