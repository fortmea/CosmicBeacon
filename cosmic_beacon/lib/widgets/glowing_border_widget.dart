import 'package:flutter/material.dart';
import 'package:cosmic_beacon/widgets/glowing_border_painter.dart';

class GlowingBorderWidget extends StatefulWidget {
  final Widget child;

  const GlowingBorderWidget({super.key, required this.child});
  @override
  _GlowingBorderWidgetState createState() => _GlowingBorderWidgetState();
}

class _GlowingBorderWidgetState extends State<GlowingBorderWidget>
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
          painter: GlowingBorderPainter(_animation),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
