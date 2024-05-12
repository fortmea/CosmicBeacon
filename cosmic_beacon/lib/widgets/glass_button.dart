import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class GlassButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  double blur;
  double borderRadius;

  GlassButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.blur = 10,
    this.borderRadius = 16,
  });

  @override
  _GlassButtonState createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  late double currentBlur = widget.blur;

  @override
  void initState() {
    super.initState();
    currentBlur = widget.blur;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (det) {
        setState(() {
          currentBlur = 100.0;
        });
      },
      onTapUp: (det) {
        setState(() {
          currentBlur = 0.0;
        });
        widget.onPressed();
      },
      child: GlassContainer(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        blur: currentBlur,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
