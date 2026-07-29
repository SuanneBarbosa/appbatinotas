import 'package:flutter/material.dart';

class HoleClipper extends CustomClipper<Path> {
  final Rect? holeRect;

  HoleClipper(this.holeRect);

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    if (holeRect != null) {
      final roundedHole = RRect.fromRectAndRadius(
        holeRect!.inflate(8),
        const Radius.circular(18),
      );

      path.addRRect(roundedHole);
      path.fillType = PathFillType.evenOdd;
    }

    return path;
  }

  @override
  bool shouldReclip(covariant HoleClipper oldClipper) {
    return oldClipper.holeRect != holeRect;
  }
}
