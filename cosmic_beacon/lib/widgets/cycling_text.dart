import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadingTextCycleWidget extends StatefulWidget {
  final List<String> texts;
  final Duration duration;

  const FadingTextCycleWidget({
    Key? key,
    required this.texts,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _FadingTextCycleWidgetState createState() => _FadingTextCycleWidgetState();
}

class _FadingTextCycleWidgetState extends State<FadingTextCycleWidget> {
  int position = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.texts[position]).animate(
      onComplete: (controller) {
        if (position < widget.texts.length - 1) {
          setState(() {
            position++;
          });
        } else {
          setState(() {
            position = 0;
          });
        }
        controller.forward(from: 0.0);
      },
    ).fade(duration: widget.duration, curve: Curves.easeInOutSine);
  }
}
