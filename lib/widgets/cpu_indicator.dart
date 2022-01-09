import 'package:flutter/material.dart';

class CpuIndicator extends StatefulWidget {
  final List<Offset> path;
  const CpuIndicator({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<CpuIndicator> createState() => _CpuIndicatorState();
}

class _CpuIndicatorState extends State<CpuIndicator>
    with SingleTickerProviderStateMixin {
  late CatmullRomSpline path2;

  AnimationController? controller;

  final Curve curve = Curves.linear;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation = CurvedAnimation(parent: controller!, curve: curve);
    controller!.repeat();
    controller!.addListener(() => setState(() {}));
    path2 = CatmullRomSpline(
      widget.path,
      startHandle: const Offset(0.93, 0.93),
      endHandle: const Offset(0.18, 0.23),
    );

    super.initState();
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
