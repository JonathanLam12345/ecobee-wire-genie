// NOTE: The following import (dart:html) is only valid on web builds.
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ecobee_wiring_diagram/paint_features/wire_painter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../main.dart';
import '../paint_features/color_picker_dialog.dart';

class PremiumWiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const PremiumWiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<PremiumWiringDiagramWidget> createState() =>
      _PremiumWiringDiagramWidgetState();
}

class _PremiumWiringDiagramWidgetState
    extends State<PremiumWiringDiagramWidget> {
  // RepaintBoundary key for capturing the image + wires
  final GlobalKey _captureKey = GlobalKey();

  // Store wire ID hitboxes for rename detection
  Map<int, Rect> wireIdHitboxes = {};

  late List<Wire> wires;
  bool showWireIds = false;

  final List<Wire> initialWiresConventional = [
    Wire(
      id: 'Rc',
      points: [Offset(322, 42), Offset(285, 42), Offset(285, 336)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(99, 137), Offset(256, 137), Offset(256, 336)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(99, 184), Offset(205, 184), Offset(205, 336)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(322, 90), Offset(149, 90), Offset(149, 336)],
      color: Colors.grey,
    ),
    Wire(
      id: 'C',
      points: [
        Offset(99, 160),
        Offset(232, 160),
        Offset(232, 190),
        Offset(315, 190),
        Offset(315, 338),
      ],
      color: Colors.blue,
    ),
  ];

  // NEW DIAGRAM WIRES (Second Column, First Row)
  final List<Wire> initial1DoorCam1Chime1Trans = [
    Wire(
      id: 'O/B',
      points: [Offset(100, 120), Offset(250, 120), Offset(250, 340)],
      color: Colors.orange,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(90, 180), Offset(200, 180), Offset(200, 340)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Aux',
      points: [Offset(330, 70), Offset(150, 70), Offset(150, 330)],
      color: Colors.white,
    ),
    Wire(
      id: 'L',
      points: [Offset(330, 40), Offset(280, 40), Offset(280, 330)],
      color: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Use different sets of wires for each diagram
    if (widget.diagramIndex == 1) {
      // Second column, first row
      wires = List.from(initial1DoorCam1Chime1Trans);
    } else {
      wires = List.from(initialWiresConventional);
    }
  }

  void resetToDefault() {
    setState(() {
      if (widget.diagramIndex == 1) {
        wires = List.from(initial1DoorCam1Chime1Trans);
      } else {
        wires = List.from(initialWiresConventional);
      }
      showWireIds = false;
    });
  }

  void toggleWireIds() => setState(() => showWireIds = !showWireIds);

  void changeWireColor(int index) async {
    final pickedColor = await showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(initialColor: wires[index].color),
    );
    if (pickedColor != null) {
      setState(() => wires[index] = wires[index].copyWith(color: pickedColor));
    }
  }

  Future<void> _renameWireId(int index) async {
    final controller = TextEditingController(text: wires[index].id);

    final newId = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename Wire ID'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Wire ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newId != null && newId.isNotEmpty) {
      setState(() {
        wires[index] = wires[index].copyWith(id: newId);
      });
    }
  }

  void _handleTap(Offset tapPos) {
    for (int i = 0; i < wires.length; i++) {
      final rect = wireIdHitboxes[i];
      if (rect != null && rect.contains(tapPos)) {
        _renameWireId(i);
        return;
      }
    }

    for (int i = 0; i < wires.length; i++) {
      for (int j = 0; j < wires[i].points.length - 1; j++) {
        if (_isPointNearLine(
          tapPos,
          wires[i].points[j],
          wires[i].points[j + 1],
        )) {
          changeWireColor(i);
          return;
        }
      }
    }
  }

  bool _isPointNearLine(Offset p, Offset a, Offset b, {double tolerance = 10}) {
    final dx = b.dx - a.dx, dy = b.dy - a.dy;
    final lengthSquared = dx * dx + dy * dy;

    if (lengthSquared == 0) return (p - a).distance <= tolerance;

    final t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / lengthSquared;

    final double tClamped = t.clamp(0.0, 1.0);

    // Calculate the closest point on the SEGMENT
    final closestPoint = Offset(a.dx + tClamped * dx, a.dy + tClamped * dy);

    // Check if the distance from the tap point to the closest point is within tolerance
    return (p - closestPoint).distance <= tolerance;
  }

  Offset _computeWirePointAtFraction(List<Offset> points, double fraction) {
    if (points.isEmpty) return Offset.zero;
    double totalLength = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalLength += (points[i + 1] - points[i]).distance;
    }
    final targetLength = totalLength * fraction;
    double distSoFar = 0;

    for (int i = 0; i < points.length - 1; i++) {
      final seg = points[i + 1] - points[i];
      final segLen = seg.distance;
      if (distSoFar + segLen >= targetLength) {
        final remain = targetLength - distSoFar;
        return points[i] + (seg / segLen) * remain;
      }
      distSoFar += segLen;
    }
    return points.last;
  }

  Future<void> _saveCapture() async {
    try {
      final boundary =
      _captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Capture area not available')),
        );
        return;
      }

      final ui.Image image = await boundary.toImage(
        pixelRatio: ui.window.devicePixelRatio,
      );
      final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image')),
        );
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      if (kIsWeb) {
        final blob = html.Blob([pngBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement;
        anchor.href = url;
        anchor.download =
        'diagram_${widget.diagramIndex}_${DateTime.now().millisecondsSinceEpoch}.png';
        html.document.body!.append(anchor);
        anchor.click();
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Captured image'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 300),
              child: Image.memory(pngBytes),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

 @override
  Widget build(BuildContext context) {
    const double imageWidth = 431, imageHeight = 414;

    // Select image based on diagram index
    final String imagePath = widget.diagramIndex == 1
        ? 'assets/doorCam1Chime1Trans.jpg' // NEW wiring diagram image
        : 'assets/conventional.png';

    final String title = widget.diagramIndex == 1
        ? "Heat Pump Installation"
        : "Conventional Heating and Cooling Installation";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SelectableText(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RepaintBoundary(
              key: _captureKey,
              child: SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Stack(
                  children: [
                    Image.asset(
                      imagePath,
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.cover,
                    ),
                    CustomPaint(
                      painter: WirePainter(
                        wires,
                        midpointCalculator: (points) =>
                            _computeWirePointAtFraction(points, 0.75),
                        showIds: showWireIds,
                        onPaintId: (i, rect) => wireIdHitboxes[i] = rect,
                      ),
                      size: const Size(imageWidth, imageHeight),
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTapDown: (details) =>
                            _handleTap(details.localPosition),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8), // Added back the missing SizedBox
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  onPressed: resetToDefault,
                  child: const Text("Reset to Default"),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                      showWireIds ? Icons.visibility : Icons.visibility_off),
                  label:
                  Text(showWireIds ? "Hide Wire IDs" : "Show Wire IDs"),
                  onPressed: toggleWireIds,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Image'),
                  onPressed: _saveCapture,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
