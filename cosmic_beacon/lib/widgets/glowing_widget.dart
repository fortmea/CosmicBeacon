import 'package:flutter/material.dart';
import 'package:cosmic_beacon/animation/glowing_painter.dart';

class GlowingWidget extends StatefulWidget {
  final Widget child;
  final PaintingStyle style;
  final double opacity;

  const GlowingWidget(
      {super.key,
      required this.child,
      this.style = PaintingStyle.stroke,
      this.opacity = 1.0});
  @override
  _GlowingWidgetState createState() => _GlowingWidgetState();
}

class _GlowingWidgetState extends State<GlowingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: GlowingPainter(
              _animation,
              [Colors.blue, Colors.deepPurple, Colors.deepOrange],
              1,
              1,
              1.5,
              opacity: widget.opacity,
              widget.style),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
