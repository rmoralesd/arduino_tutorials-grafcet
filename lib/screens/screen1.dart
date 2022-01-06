import 'package:flutter/material.dart';
import 'package:grafcet/widgets/widgets.dart';

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
                  const CpuIndicator(
                    path: <Offset>[
                      Offset(1028, 138),
                      Offset(1028, 420),
                      Offset(800, 420),
                      Offset(800, 138),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
