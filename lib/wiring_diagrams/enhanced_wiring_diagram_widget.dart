// NOTE: The following import (dart:html) is only valid on web builds.
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../main.dart';
import '../paint_features/color_picker_dialog.dart';
import '../paint_features/wire_painter.dart';

class EnhancedWiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const EnhancedWiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<EnhancedWiringDiagramWidget> createState() =>
      _EnhancedWiringDiagramWidgetState();
}

class _EnhancedWiringDiagramWidgetState
    extends State<EnhancedWiringDiagramWidget> {
  // RepaintBoundary key for capturing the image + wires
  final GlobalKey _captureKey = GlobalKey();

  // Store wire ID hitboxes for rename detection
  Map<int, Rect> wireIdHitboxes = {};

  late List<Wire> wires;
  bool showWireIds = false;

  // The only wires we care about for the Enhanced screen (Index 1)
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
    // Always use the specific Heat Pump wires (index 1) for the Enhanced Screen
    wires = List.from(initial1DoorCam1Chime1Trans);
  }

  void resetToDefault() {
    setState(() {
      wires = List.from(initial1DoorCam1Chime1Trans);
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
    final closestPoint = Offset(a.dx + tClamped * dx, a.dy + tClamped * dy);

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
    // Save capture logic, identical to the Premium widget
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
        'diagram_enhanced_${DateTime.now().millisecondsSinceEpoch}.png';
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
    const String imagePath = 'assets/doorCam1Chime1Trans.jpg';
    const String title = "Enhanced: Heat Pump Installation";

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
            const SizedBox(height: 8),
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
