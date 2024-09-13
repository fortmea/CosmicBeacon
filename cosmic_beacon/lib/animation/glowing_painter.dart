import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlowingPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Color> colors;
  final double strokeWidth;
  final double blurWidth;
  final double animationScaling;
  final PaintingStyle style;
  final double opacity;

  GlowingPainter(this.animation, this.colors, this.strokeWidth, this.blurWidth,
      this.animationScaling, this.style,
      {this.opacity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final double angle = animation.value * 2 * math.pi;

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: GradientRotation(angle),
      ).createShader(rect)
      ..style = style
      ..strokeWidth = strokeWidth + animation.value
      ..maskFilter =
          MaskFilter.blur(BlurStyle.solid, animation.value * animationScaling)
      ..color = Colors.white.withOpacity(opacity); // Set opacity here

    final RRect rrect =
        RRect.fromRectAndRadius(rect, const Radius.circular(12));

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
