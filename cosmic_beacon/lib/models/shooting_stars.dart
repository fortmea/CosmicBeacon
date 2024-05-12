import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class ShootingStarsBackground extends StatefulWidget {
  const ShootingStarsBackground({Key? key}) : super(key: key);

  @override
  _ShootingStarsBackgroundState createState() =>
      _ShootingStarsBackgroundState();

  static _ShootingStarsBackgroundState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ShootingStarsBackgroundState>();
  }
}

class _ShootingStarsBackgroundState extends State<ShootingStarsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final List<BrightPoint> _brightPoints = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _controller.addListener(() {
      setState(() {
        _stars.removeWhere((star) =>
            star.position.dx < -50 ||
            star.position.dy > MediaQuery.of(context).size.height);
        for (var star in _stars) {
          star.position = Offset(star.position.dx - 2, star.position.dy + 1);
        }

        _brightPoints.removeWhere((point) =>
            point.position.dx < 0 ||
            point.position.dy > MediaQuery.of(context).size.height);
        for (var point in _brightPoints) {
          point.position = Offset(point.position.dx - .3, point.position.dy);
        }

        if (Random().nextInt(1000) < 5) {
          _stars.add(Star(Offset(
              MediaQuery.of(context).size.width,
              Random().nextDouble() *
                  MediaQuery.of(context).size.height)));
        }

        if (Random().nextInt(100) < 2) {
          _brightPoints.add(BrightPoint(Offset(
              MediaQuery.of(context).size.width,
              Random().nextDouble() *
                  MediaQuery.of(context).size.height)));
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShootingStarsPainter(_stars, _brightPoints),
    );
  }
}

class Star {
  Offset position;

  Star(this.position);
}

class BrightPoint {
  Offset position;

  BrightPoint(this.position);
}

class ShootingStarsPainter extends CustomPainter {
  final List<Star> stars;
  final List<BrightPoint> brightPoints;

  ShootingStarsPainter(this.stars, this.brightPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white;
    final pointPaint = Paint()
      ..color = const Color.fromARGB(255, 141, 141, 140);

    for (var star in stars) {
      canvas.drawCircle(star.position, 2, starPaint);
      for (int i = 1; i <= 20; i++) {
        final alpha = (1 - i / 20) * 255;
        final trailPaint = Paint()
          ..color = Colors.white.withOpacity(alpha / 255)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;
        final trailPosition =
            Offset(star.position.dx + i * 2, star.position.dy - i * 1);
        canvas.drawPoints(PointMode.points, [trailPosition], trailPaint);
      }
    }

    for (var point in brightPoints) {
      canvas.drawCircle(point.position, 1, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
