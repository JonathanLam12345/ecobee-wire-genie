import 'package:flutter/material.dart';

import '../main.dart';
class WirePainter extends CustomPainter {
  final List<Wire> wires;
  final Offset Function(List<Offset>) midpointCalculator;
  final bool showIds;
  final void Function(int, Rect) onPaintId;

  WirePainter(
      this.wires, {
        required this.midpointCalculator,
        required this.showIds,
        required this.onPaintId,
      });

  @override
  void paint(Canvas canvas, Size size) {
    for (int index = 0; index < wires.length; index++) {
      final wire = wires[index];

      final paint = Paint()
        ..color = wire.color
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(wire.points.first.dx, wire.points.first.dy);
      for (int i = 1; i < wire.points.length; i++) {
        path.lineTo(wire.points[i].dx, wire.points[i].dy);
      }
      canvas.drawPath(path, paint);

      if (showIds) {
        final midpoint = midpointCalculator(wire.points);
        const padding = 4.0;
        final textPainter = TextPainter(
          text: TextSpan(
            text: wire.id,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black45, blurRadius: 3)],
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final rect = Rect.fromLTWH(
          midpoint.dx - textPainter.width / 2 - padding,
          midpoint.dy - textPainter.height / 2 - padding,
          textPainter.width + 2 * padding,
          textPainter.height + 2 * padding,
        );

        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
        final bgPaint = Paint()..color = Colors.black.withOpacity(0.5);
        canvas.drawRRect(rrect, bgPaint);

        textPainter.paint(
          canvas,
          Offset(midpoint.dx - textPainter.width / 2,
              midpoint.dy - textPainter.height / 2),
        );

        // Report hitbox back
        onPaintId(index, rect);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}