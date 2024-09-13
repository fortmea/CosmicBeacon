import 'package:flutter/material.dart';

Widget listFade({required Widget child}) {
  return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.transparent,
            Colors.transparent,
            Colors.white
          ],
          stops: [0.0, 0.05, 0.95, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child);
}

Widget horizontalListFade({required Widget child}) {
  return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            Colors.transparent,
            Colors.transparent,
            Colors.white
          ],
          stops: [0.0, 0.05, 0.95, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child);
}
