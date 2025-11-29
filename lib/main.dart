import 'package:flutter/material.dart';

void main() => runApp(const WiringApp());

class WiringApp extends StatelessWidget {
  const WiringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiring Schematic',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WiringScreen(),
    );
  }
}

class Wire {
  final String id;
  final List<Offset> points;
  Color color;

  Wire({required this.id, required this.points, required this.color});

  Wire copyWith({Color? color}) => Wire(id: id, points: points, color: color ?? this.color);
}

class WiringScreen extends StatefulWidget {
  const WiringScreen({super.key});

  @override
  State<WiringScreen> createState() => _WiringScreenState();
}

class _WiringScreenState extends State<WiringScreen> {
  final List<Wire> initialWires = [
    Wire(id: 'R', points: [Offset(423, 501), Offset(423, 63),Offset(486, 63)], color: Colors.red),
    // Wire(id: 'C', points: [Offset(50, 100), Offset(250, 100)], color: Colors.blue),
    // Wire(id: 'G', points: [Offset(50, 150), Offset(150, 200), Offset(250, 150)], color: Colors.green),
    // Wire(id: 'Y', points: [Offset(50, 200), Offset(150, 250), Offset(250, 250)], color: Colors.yellow),
    // Wire(id: 'W', points: [Offset(50, 250), Offset(150, 300), Offset(250, 350)], color: Colors.grey),
  ];

  late List<Wire> wires;
  bool showWireIds = false; // Wire IDs hidden by default

  @override
  void initState() {
    super.initState();
    wires = List.from(initialWires);
  }

  void resetToDefault() => setState(() => wires = List.from(initialWires));
  void toggleWireIds() => setState(() => showWireIds = !showWireIds);

  void changeWireColor(int index) async {
    final pickedColor = await showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(initialColor: wires[index].color),
    );
    if (pickedColor != null) setState(() => wires[index] = wires[index].copyWith(color: pickedColor));
  }

  bool _isPointNearLine(Offset p, Offset a, Offset b, {double tolerance = 10}) {
    final dx = b.dx - a.dx, dy = b.dy - a.dy;
    final lengthSquared = dx * dx + dy * dy;
    if (lengthSquared == 0) return (p - a).distance <= tolerance;
    final t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / lengthSquared;
    final projection = Offset(a.dx + t * dx, a.dy + t * dy);
    return (p - projection).distance <= tolerance;
  }

  Offset _computeWireMidpoint(List<Offset> points) {
    if (points.isEmpty) return Offset.zero;
    double totalLength = 0;
    for (int i = 0; i < points.length - 1; i++) totalLength += (points[i + 1] - points[i]).distance;
    final halfLength = totalLength / 2;
    double distSoFar = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final seg = points[i + 1] - points[i];
      final segLen = seg.distance;
      if (distSoFar + segLen >= halfLength) {
        final remain = halfLength - distSoFar;
        return points[i] + (seg / segLen) * remain;
      }
      distSoFar += segLen;
    }
    return points.last;
  }

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 639, imageHeight = 614;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Stack(
                  children: [
                    Image.asset('assets/conventional.png', width: imageWidth, height: imageHeight, fit: BoxFit.cover),
                    CustomPaint(
                      painter: WirePainter(
                        wires,
                        midpointCalculator: _computeWireMidpoint,
                        showIds: showWireIds,
                      ),
                      size: const Size(imageWidth, imageHeight),
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTapDown: (details) {
                          final tapPos = details.localPosition;
                          for (int i = 0; i < wires.length; i++) {
                            for (int j = 0; j < wires[i].points.length - 1; j++) {
                              if (_isPointNearLine(tapPos, wires[i].points[j], wires[i].points[j + 1])) {
                                changeWireColor(i);
                                return;
                              }
                            }
                          }
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: resetToDefault,
                child: const Text("Reset to Default"),
              ),   // Toggle button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ElevatedButton.icon(
                  icon: Icon(showWireIds ? Icons.visibility : Icons.visibility_off),
                  label: Text(showWireIds ? "Hide Wire IDs" : "Show Wire IDs"),
                  onPressed: toggleWireIds,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WirePainter extends CustomPainter {
  final List<Wire> wires;
  final Offset Function(List<Offset>) midpointCalculator;
  final bool showIds;

  WirePainter(this.wires, {required this.midpointCalculator, required this.showIds});

  @override
  void paint(Canvas canvas, Size size) {
    for (final wire in wires) {
      // Draw wire
      final paint = Paint()
        ..color = wire.color
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path()..moveTo(wire.points.first.dx, wire.points.first.dy);
      for (int i = 1; i < wire.points.length; i++) path.lineTo(wire.points[i].dx, wire.points[i].dy);
      canvas.drawPath(path, paint);

      // Draw wire ID if enabled
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
              shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
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

        textPainter.paint(canvas, Offset(midpoint.dx - textPainter.width / 2, midpoint.dy - textPainter.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;

  const ColorPickerDialog({super.key, required this.initialColor});

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.purple, Colors.black];

    return AlertDialog(
      title: const Text('Pick a color'),
      content: Wrap(
        spacing: 8,
        children: colors
            .map(
              (c) => GestureDetector(
            onTap: () => Navigator.pop(context, c),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: c == initialColor ? 3 : 1),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
