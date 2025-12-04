// NOTE: The following import (dart:html) is only valid on web builds.
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../paint_features/color_picker_dialog.dart';
import '../paint_features/wire_painter.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

class DoorbellWiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const DoorbellWiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<DoorbellWiringDiagramWidget> createState() =>
      _PremiumWiringDiagramWidgetState();
}

class _PremiumWiringDiagramWidgetState
    extends State<DoorbellWiringDiagramWidget> {
  // Firebase Analytics instance
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // RepaintBoundary key for capturing the image + wires
  final GlobalKey _captureKey = GlobalKey();

  Map<int, Rect> wireIdHitboxes = {};

  late List<Wire> wires;
  bool showWireIds = false;

  final List<Wire> doorbell1 = [
    Wire(
      id: 'doorbell1',
      points: [Offset(63, 159), Offset(85, 159)],
      color: Colors.black,
    ),
    Wire(
      id: 'doorbell2',
      points: [Offset(63, 237), Offset(103, 237), Offset(103, 233)],
      color: Colors.black,
    ),
    Wire(
      id: 'TRANS',
      points: [Offset(123, 159), Offset(159, 159), Offset(158, 156)],
      color: Colors.black,
    ),
  ];

  final List<Wire> doorbell2 = [
    Wire(
      id: 'doorbell1',
      points: [Offset(197, 155), Offset(280, 155)],
      color: Colors.black,
    ),
    Wire(
      id: 'doorbell2',
      points: [Offset(197, 326), Offset(338, 326), Offset(338, 170)],
      color: Colors.black,
    ),
  ];

  ////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> doorbell3 = [
    Wire(
      id: 'doorbell1',
      points: [Offset(63, 151), Offset(86, 151)],
      color: Colors.black,
    ),
    Wire(
      id: 'doorbell2',
      points: [Offset(62, 228), Offset(102, 228), Offset(102, 225)],
      color: Colors.black,
    ),
    Wire(
      id: 'TRANS',
      points: [Offset(123, 151), Offset(147, 151), Offset(148, 146)],

      color: Colors.black,
    ),

    Wire(
      id: 'button-wiring1',
      points: [Offset(51, 292), Offset(151, 292), Offset(151, 146)],

      color: Colors.black,
    ),

    Wire(
      id: 'button-wiring2',
      points: [Offset(51, 322), Offset(103, 322), Offset(103, 319)],

      color: Colors.black,
    ),
  ];

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> doorbell4 = [
    Wire(
      id: 'doorbell1',
      points: [Offset(57, 118), Offset(127, 119)],
      color: Colors.black,
    ),
    Wire(
      id: 'doorbell2',
      points: [Offset(56, 186), Offset(154, 187), Offset(154, 184)],
      color: Colors.black,
    ),
    Wire(
      id: 'TRANS',
      points: [Offset(158, 119), Offset(180, 119), Offset(180, 115)],
      color: Colors.black,
    ),
    Wire(
      id: 'doorbell1',
      points: [Offset(116, 263), Offset(134, 262), Offset(134, 125)],
      color: Colors.black,
    ),
    Wire(
      id: 'doorbell2',
      points: [Offset(117, 296), Offset(184, 296), Offset(181, 115)],
      color: Colors.black,
    ),
  ];

  final List<Wire> doorbell5 = [
    Wire(
      id: 'doorbell1',
      points: [Offset(96, 120), Offset(118, 120)],
      color: Colors.black,
    ),
    Wire(
      id: 'doorbell2',
      points: [Offset(97, 191), Offset(132, 191), Offset(132, 188)],
      color: Colors.black,
    ),
    Wire(
      id: 'TRANS',
      points: [Offset(152, 120), Offset(178, 120), Offset(178, 117)],
      color: Colors.black,
    ),
    Wire(
      id: 'button1',
      points: [Offset(83, 270), Offset(176, 268), Offset(175, 117)],
      color: Colors.black,
    ),
    Wire(
      id: 'button2',
      points: [Offset(84, 300), Offset(131, 300), Offset(132, 295)],

      color: Colors.black,
    ),

    Wire(
      id: 'button1',
      points: [Offset(33, 232), Offset(175, 232), Offset(175, 117)],

      color: Colors.black,
    ),
    Wire(
      id: 'button2',
      points: [
        Offset(33, 260),
        Offset(46, 260),
        Offset(46, 335),
        Offset(134, 335),
        Offset(134, 295),
      ],
      color: Colors.black,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Use different sets of wires for each diagram
    if (widget.diagramIndex == 0) {
      wires = List.from(doorbell1);
    } else if (widget.diagramIndex == 1) {
      wires = List.from(doorbell2);
    } else if (widget.diagramIndex == 2) {
      wires = List.from(doorbell3);
    } else if (widget.diagramIndex == 3) {
      wires = List.from(doorbell4);
    } else if (widget.diagramIndex == 4) {
      wires = List.from(doorbell5);
    } else if (widget.diagramIndex == 5) {
      wires = List.from(doorbell5);
    }
  }

  void resetToDefault() {
    setState(() {
      if (widget.diagramIndex == 0) {
        wires = List.from(doorbell1);
      } else if (widget.diagramIndex == 1) {
        wires = List.from(doorbell2);
      } else if (widget.diagramIndex == 2) {
        wires = List.from(doorbell3);
      } else if (widget.diagramIndex == 3) {
        wires = List.from(doorbell4);
      } else if (widget.diagramIndex == 4) {
        wires = List.from(doorbell5);
      } else if (widget.diagramIndex == 5) {
        wires = List.from(doorbell5);
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
          _captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Capture area not available')),
        );
        return;
      }

      final ui.Image image = await boundary.toImage(
        pixelRatio: ui.window.devicePixelRatio,
      );
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image')),
        );
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      if (kIsWeb) {
        final title = widget.diagramIndex == 0
            ? "Doorbell Camera-1"
            : widget.diagramIndex == 1
            ? 'oorbell Camera-2'
            : widget.diagramIndex == 2
            ? 'Doorbell Camera-3'
            : widget.diagramIndex == 3
            ? 'Doorbell Camera-4'
            : widget.diagramIndex == 4
            ? 'Doorbell Camera-5'
            : 'Doorbell Camera-6';

        final title2 = title
            .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
            .replaceAll(' ', '_'); // Replace spaces with underscores

        final blob = html.Blob([pngBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement;
        anchor.href = url;

        // 3. Set the new filename using the sanitized title
        anchor.download = '$title2.png';

        // Log analytics event
        await analytics.logEvent(
          name: 'doorbell_image_download',
          parameters: {
            'diagram_title': title2,
            'diagram_index': widget.diagramIndex,
          },
        );

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
    const double imageWidth = 420, imageHeight = 420;

    final String imagePath = widget.diagramIndex == 0
        ? 'assets/1-doorbell-1-chime-1-transformer.png'
        : widget.diagramIndex == 1
        ? 'assets/1-doorbell-camera_1-plugin-transformer.png'
        : widget.diagramIndex == 2
        ? 'assets/1-doorbell-camera-1-doorbell-button-1-chime-1-transformer.png'
        : widget.diagramIndex == 3
        ? 'assets/2-doorbell-cameras-1-chime_1-transformer.png'
        : widget.diagramIndex == 4
        ? 'assets/1-doorbell-camera_2-or-more-doorbell-buttons_1-chime_1-transformer.png'
        : 'assets/1-doorbell-camera_2-or-more-doorbell-buttons_1-chime_1-transformer.png';

    final String title = widget.diagramIndex == 0
        ? "1 Doorbell Camera, 1 Chime Box"
        : widget.diagramIndex == 1
        ? '1 Doorbell Camera, Plug-in Transformer'
        : widget.diagramIndex == 2
        ? '1 Doorbell Camera, 1 Doorbell Button, 1 Chime Box'
        : widget.diagramIndex == 3
        ? '1 Doorbell Camera, 1 Doorbell Button, 1 Chime Box'
        : widget.diagramIndex == 4
        ? '1 Doorbell Camera, 2 Doorbell Button, 1 Chime Box'
        : 'Dual Transformer Installation';

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                  ),
                  onPressed: resetToDefault,
                  child: const Text("Reset to Default"),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    showWireIds ? Icons.visibility : Icons.visibility_off,
                  ),
                  label: Text(showWireIds ? "Hide Wire IDs" : "Show Wire IDs"),
                  onPressed: toggleWireIds,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Image'),
                  onPressed: _saveCapture,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
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
