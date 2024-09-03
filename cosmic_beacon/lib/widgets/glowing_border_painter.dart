import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlowingBorderPainter extends CustomPainter {
  final Animation<double> animation;

  GlowingBorderPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // Calcula os ângulos para rotacionar o gradiente
    final double angle = animation.value * 2 * math.pi;
    final Offset center = rect.center;
    final double radius = rect.shortestSide / 2;

    final Offset startPoint = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final Offset endPoint = Offset(
      center.dx - radius * math.cos(angle),
      center.dy - radius * math.sin(angle),
    );

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: const [
          Colors.blue,
          Colors.purple,
          Colors.red,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: GradientRotation(angle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 + animation.value * 2
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1 + animation.value * 4);

    final RRect rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
