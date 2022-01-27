import 'package:flutter/material.dart';
import 'package:grafcet/models/flow_diagram.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';

class CPUIndicator extends StatefulWidget {
  final NodeFlowDiagram? Function() getNextNode;
  const CPUIndicator({
    Key? key,
    required this.getNextNode,
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

    return Positioned(
      top: node.y,
      left: node.x,
      child: Image.asset(
        'assets/images/arrow.gif',
        width: 50,
        height: 50,
      ),
    );
  }
}
