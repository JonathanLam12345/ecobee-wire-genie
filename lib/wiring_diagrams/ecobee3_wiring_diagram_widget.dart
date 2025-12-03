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

class Ecobee3WiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const Ecobee3WiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<Ecobee3WiringDiagramWidget> createState() =>
      _Ecobee3WiringDiagramWidgetState();
}

class _Ecobee3WiringDiagramWidgetState
    extends State<Ecobee3WiringDiagramWidget> {
  final GlobalKey _captureKey = GlobalKey();

  Map<int, Rect> wireIdHitboxes = {};

  late List<Wire> wires;
  bool showWireIds = false;

  final List<Wire> conventional = [
    Wire(
      id: 'Rh',
      points: [Offset(315, 88), Offset(253, 90), Offset(250, 258)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(96, 121), Offset(278, 122), Offset(281, 258)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(95, 138), Offset(187, 139), Offset(191, 258)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(94, 156), Offset(216, 157), Offset(220, 259)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [Offset(315, 106), Offset(269, 109), Offset(267, 258)],
      color: Colors.blue,
    ),
  ];

  final List<Wire> heatPump = [
    Wire(
      id: 'Rh',
      points: [Offset(315, 88), Offset(285, 90), Offset(283, 259)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(95, 118), Offset(264, 119), Offset(267, 259)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(95, 135), Offset(236, 137), Offset(238, 259)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(95, 153), Offset(205, 155), Offset(208, 258)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'O/B',
      points: [Offset(96, 171), Offset(190, 173), Offset(193, 259)],
      color: Colors.orange,
    ),
    Wire(
      id: 'C',
      points: [Offset(315, 106), Offset(300, 106), Offset(299, 259)],
      color: Colors.blue,
    ),
  ];

  final List<Wire> dual = [
    Wire(
      id: 'Rh',
      points: [Offset(308, 93), Offset(245, 93), Offset(243, 248)],
      color: Colors.red,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(98, 104), Offset(167, 104), Offset(167, 192)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(99, 123), Offset(198, 123), Offset(198, 192)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(98, 139), Offset(139, 139), Offset(139, 192)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(96, 156), Offset(228, 156), Offset(229, 248)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [Offset(308, 109), Offset(184, 109), Offset(183, 192)],

      color: Colors.blue,
    ),
    Wire(
      id: 'AC Y1',
      points: [Offset(138, 228), Offset(138, 247)],

      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [Offset(183, 229), Offset(183, 238),Offset(167, 238), Offset(167, 247)],

      color: (Colors.grey[350])!,
    )
  ];

  final List<Wire> heatPumpPEK = [
    Wire(
      id: 'Rh',
      points: [
        Offset(65, 65),
        Offset(91, 66),
        Offset(94, 285),
        Offset(125, 286),
      ],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [
        Offset(65, 80),
        Offset(101, 81),
        Offset(104, 278),
        Offset(125, 279),
      ],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [
        Offset(65, 95),
        Offset(82, 97),
        Offset(86, 272),
        Offset(124, 273),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [
        Offset(65, 108),
        Offset(73, 109),
        Offset(76, 265),
        Offset(124, 266),
      ],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'O/B',
      points: [
        Offset(65, 126),
        Offset(117, 127),
        Offset(121, 176),
        Offset(375, 180),
        Offset(377, 261),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'PEK Y',
      points: [Offset(179, 204), Offset(363, 205), Offset(365, 260)],
      color: Colors.yellow,
    ),

    Wire(
      id: 'PEK W',
      points: [Offset(179, 210), Offset(350, 212), Offset(352, 260)],
      color: Colors.grey,
    ),
    Wire(
      id: 'PEK G',
      points: [Offset(179, 217), Offset(325, 223), Offset(338, 260)],
      color: Colors.green,
    ),
    Wire(
      id: 'PEK C',
      points: [Offset(179, 222), Offset(325, 224), Offset(326, 260)],
      color: Colors.blue,
    ),
    Wire(
      id: 'PEK R',
      points: [Offset(179, 229), Offset(311, 231), Offset(312, 260)],
      color: Colors.red,
    ),


  ];

  final List<Wire> accessory = [
    Wire(
      id: '24V to ACC+',
      points:  [Offset(196, 199), Offset(323, 199)],
      color: Colors.red,
    ),

    Wire(
      id: 'C to ACC-',
      points: [Offset(194, 215), Offset(323, 215)],
      color: Colors.blue,
    ),
    Wire(
      id: '24V to ACC+',
      points:  [Offset(194, 262), Offset(324, 262)]
      ,
      color: Colors.red,
    ),

    Wire(
      id: 'C to ACC-',
      points:  [Offset(196, 279), Offset(255, 281), Offset(257, 297)],
      color: Colors.blue,
    ),
  ];


  @override
  void initState() {
    super.initState();
    // Use different sets of wires for each diagram
    if (widget.diagramIndex == 0) {
      wires = List.from(conventional);
    } else if (widget.diagramIndex == 1) {
      wires = List.from(heatPump);
    } else if (widget.diagramIndex == 2) {
      wires = List.from(heatPumpPEK);
    } else if (widget.diagramIndex == 3) {
      wires = List.from(dual);
    } else if (widget.diagramIndex == 4) {
      wires = List.from(accessory);
    }
  }

  void resetToDefault() {
    setState(() {
      if (widget.diagramIndex == 0) {
        wires = List.from(conventional);
      } else if (widget.diagramIndex == 1) {
        wires = List.from(heatPump);
      } else if (widget.diagramIndex == 2) {
        wires = List.from(heatPumpPEK);
      } else if (widget.diagramIndex == 3) {
        wires = List.from(dual);
      } else if (widget.diagramIndex == 4) {
        wires = List.from(accessory);
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
      builder: (_) =>
          AlertDialog(
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
    final dx = b.dx - a.dx,
        dy = b.dy - a.dy;
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
        final blob = html.Blob([pngBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement;
        anchor.href = url;
        anchor.download =
        'diagram_${widget.diagramIndex}_${DateTime
            .now()
            .millisecondsSinceEpoch}.png';
        html.document.body!.append(anchor);
        anchor.click();
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      } else {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: const Text('Captured image'),
                content: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 400, maxWidth: 300),
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
    const double imageWidth = 420,
        imageHeight = 420;

    final String imagePath = widget.diagramIndex == 0
        ? 'assets/ecobee3_Wiring_Conventional-1.png'
        : widget.diagramIndex == 1
        ? 'assets/ecobee3_Wiring_HeatPump-1.png'
        : widget.diagramIndex == 2
        ? 'assets/ecobee3-stg-heatpump-1-stg-aux-with-PEK.png'
        : widget.diagramIndex == 3
        ? 'assets/ecobee3_Wiring_Boiler-1.png'
        : 'assets/ecobee3_Wiring_Accessory-1.png';

    final String title = widget.diagramIndex == 0
        ? "Conventional Heating and Cooling Installation"
        : widget.diagramIndex == 1
        ? 'Heat Pump Installation'
        : widget.diagramIndex == 2
        ? 'Heat Pump with PEK Installation'
        : widget.diagramIndex == 3
        ? 'Dual Transformer Installation'
        : 'Accessory Installation';

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
                  onPressed: () {
                    _saveCapture();
                  },
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
