import 'package:flutter/material.dart';

class DDHighlighter extends CustomPainter {
  final Rect sectionRect;
  final double borderRadius;

  DDHighlighter({required this.sectionRect, this.borderRadius = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.2);

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Add rounded rectangle as hole
    path.addRRect(
      RRect.fromRectAndRadius(sectionRect, Radius.circular(borderRadius)),
    );

    path.fillType = PathFillType.evenOdd; // important to make the "hole"

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
