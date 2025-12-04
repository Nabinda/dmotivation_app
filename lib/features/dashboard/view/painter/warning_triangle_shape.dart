import 'package:flutter/material.dart';

class WarningTriangleShape extends OutlinedBorder {
  final double cornerRadius;

  const WarningTriangleShape({this.cornerRadius = 8.0});

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      WarningTriangleShape(cornerRadius: cornerRadius);
  Path getTriangle(Size size, double radius) {
    final path = Path();
    path.moveTo(0.0 + radius, size.height - radius * 1.4);
    path.arcToPoint(
      Offset(0.0 + (radius * 2), size.height),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width - radius * 2, size.height);
    path.arcToPoint(
      Offset(size.width - radius, size.height - radius * 1.4),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width / 2 + radius, 0.0 + radius * 2);
    path.arcToPoint(
      Offset(size.width / 2 - radius, 0.0 + radius * 2),
      radius: Radius.circular(radius * 1.1),
      clockwise: false,
    );
    path.close();
    return path;
  }

  // Refined Path logic to ensure it fits the rect tightly while maintaining the equilateral look
  // The provided logic in the prompt had some offset issues with standard FAB sizing (squares),
  // so I've optimized the arc points above to ensure it doesn't clip awkwardly in a 46x46 box.

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Center the triangle horizontally in the rect
    // Adjust height to preserve aspect ratio if needed, but FABs are usually 1:1
    return getTriangle(rect.size, cornerRadius);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    final paint = side.toPaint()
      ..isAntiAlias = true
      ..strokeWidth = side.width == 0 ? 1.6 : side.width
      ..style = PaintingStyle.stroke;
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) =>
      WarningTriangleShape(cornerRadius: cornerRadius * t);
}
