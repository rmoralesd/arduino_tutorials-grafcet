import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.navigate_before)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.navigate_next_outlined)),
        ],
      ),
      body: Row(
        children: [
          const SizedBox(
            width: 50,
          ),
          Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/diagrama_general.png',
                  ),
                  CpuIndicator()
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class CpuIndicator extends StatefulWidget {
  const CpuIndicator({
    Key? key,
  }) : super(key: key);

  @override
  State<CpuIndicator> createState() => _CpuIndicatorState();
}

class _CpuIndicatorState extends State<CpuIndicator>
    with SingleTickerProviderStateMixin {
  final CatmullRomSpline path2 = CatmullRomSpline(
    const <Offset>[
      Offset(1028, 138),
      Offset(1028, 420),
      Offset(800, 420),
      Offset(800, 138),
    ],
    startHandle: const Offset(0.93, 0.93),
    endHandle: const Offset(0.18, 0.23),
  );

  AnimationController? controller;

  Animation<double>? path;

  final Curve curve = Curves.easeInOut;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    path = Tween(begin: 0.0, end: 200.0).animate(
      controller!,
    );
    animation = CurvedAnimation(parent: controller!, curve: curve);
    controller!.repeat();
    controller!.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Offset position =
        path2.transform(animation.value) - const Offset(525, 115);
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Image.asset(
        'assets/images/arrow.gif',
        width: 50,
        height: 50,
      ),
    );

    // controller!.forward();
    // return AnimatedBuilder(
    //   animation: controller!,
    //   builder: (BuildContext context, Widget? child) {
    //     return Positioned(
    //       top: path?.value,
    //       left: 988 - 525 - 50,
    //       child: Image.asset(
    //         'assets/images/arrow.gif',
    //         width: 50,
    //         height: 50,
    //       ),
    //     );
    //   },
    // );
    // return Positioned(
    //   top: 260 - 115 + 12,
    //   left: 988 - 525 - 50,
    //   child: Image.asset(
    //     'assets/images/arrow.gif',
    //     width: 50,
    //     height: 50,
    //   ),
    // );
  }
}
