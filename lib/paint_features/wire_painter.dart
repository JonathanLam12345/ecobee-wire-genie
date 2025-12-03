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

      // 1. Create the Path
      final path = Path()
        ..moveTo(wire.points.first.dx, wire.points.first.dy);
      for (int i = 1; i < wire.points.length; i++) {
        path.lineTo(wire.points[i].dx, wire.points[i].dy);
      }


      // final outlinePaint = Paint()
      //   ..color = Colors.black
      //   ..strokeWidth = 0 // Slightly thicker than the main wire (5 + 2 = 7)
      //   ..style = PaintingStyle.stroke
      //   ..strokeCap = StrokeCap.round;
      //
      // // 3. Draw the black outline first
      // canvas.drawPath(path, outlinePaint);


      // 4. Define the main wire paint (original logic)
      final mainWirePaint = Paint()
        ..color = wire.color
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // 5. Draw the main colored wire on top of the outline
      canvas.drawPath(path, mainWirePaint);


      if (showIds) {
        final midpoint = midpointCalculator(wire.points);
        const padding = 4.0;
        final textPainter = TextPainter(
          text: TextSpan(
            text: wire.id,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
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

        onPaintId(index, rect);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class Wire {
  final String id;
  final List<Offset> points;
  Color color;

  Wire({required this.id, required this.points, required this.color});

  Wire copyWith({String? id, Color? color}) =>
      Wire(id: id ?? this.id, points: points, color: color ?? this.color);
}