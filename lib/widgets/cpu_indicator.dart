import 'package:flutter/material.dart';

class CpuIndicator extends StatefulWidget {
  final List<Offset> path;
  final int voidLoopIndex;
  const CpuIndicator({
    Key? key,
    required this.path,
    this.voidLoopIndex = 0,
  }) : super(key: key);

  @override
  State<CpuIndicator> createState() => _CpuIndicatorState();
}

class _CpuIndicatorState extends State<CpuIndicator>
    with SingleTickerProviderStateMixin {
  late CatmullRomSpline path2;
  bool isFirstRun = true;

  AnimationController? controller;

  final Curve curve = Curves.linear;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.path.length * 200));
    animation = CurvedAnimation(parent: controller!, curve: curve);
    controller!.forward();
    path2 = CatmullRomSpline(
      widget.path,
      startHandle: const Offset(0.93, 0.93),
      endHandle: const Offset(0.18, 0.23),
    );
    controller!.addListener(() => setState(() {}));
    controller!.addStatusListener(_setToLoop);

    super.initState();
  }

  void _setToLoop(status) {
    if (status == AnimationStatus.completed && isFirstRun) {
      isFirstRun = false;
      var pathLoop = widget.path.sublist(widget.voidLoopIndex);
      controller!.duration = Duration(milliseconds: pathLoop.length * 200);
      controller!.repeat();
      path2 = CatmullRomSpline(
        isFirstRun ? widget.path : pathLoop,
        startHandle: const Offset(0.93, 0.93),
        endHandle: const Offset(0.18, 0.23),
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Offset position = path2.transform(animation.value);
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Image.asset(
        'assets/images/arrow.gif',
        width: 50,
        height: 50,
      ),
    );
  }
}
