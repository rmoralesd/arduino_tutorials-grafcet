import 'package:flutter/material.dart';

class CpuIndicator extends StatefulWidget {
  final List<Offset> path;
  final int voidLoopIndex;
  final bool isPlaying;
  const CpuIndicator(
      {Key? key,
      required this.path,
      this.voidLoopIndex = 0,
      this.isPlaying = true})
      : super(key: key);

  @override
  State<CpuIndicator> createState() => _CpuIndicatorState();

  void stop() {}
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
    _initialValues();
    super.initState();
  }

  void _initialValues() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.path.length * 200));
    animation = CurvedAnimation(parent: controller!, curve: curve);
    path2 = CatmullRomSpline(
      widget.path,
      startHandle: const Offset(0.93, 0.93),
      endHandle: const Offset(0.18, 0.23),
    );
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
    _prepareController();
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

  void _prepareController() {
    if (widget.isPlaying) {
      if (isFirstRun) {
        controller!.addListener(() {
          setState(() {});
        });
        controller!.addStatusListener((status) {
          _setToLoop(status);
        });
        controller!.forward();
      } else {
        controller!.repeat();
      }
    } else if (!widget.isPlaying) {
      controller!.stop();
    }
  }
}
