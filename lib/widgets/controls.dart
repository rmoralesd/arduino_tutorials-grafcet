import 'package:flutter/material.dart';

class ControlsBar extends StatelessWidget {
  final Function()? OnGoPrevious;
  final Function()? OnGoNext;
  final Function()? OnStop;
  final Function()? OnPlayPause;
  final bool isPlaying;
  const ControlsBar({
    Key? key,
    this.OnGoPrevious,
    this.OnGoNext,
    this.OnStop,
    this.OnPlayPause,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: OnGoPrevious, icon: const Icon(Icons.navigate_before)),
        IconButton(onPressed: OnStop, icon: const Icon(Icons.stop)),
        IconButton(
          onPressed: OnPlayPause,
          icon: isPlaying
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
        ),
        IconButton(
            onPressed: OnGoNext,
            icon: const Icon(Icons.navigate_next_outlined)),
      ],
    );
  }
}
