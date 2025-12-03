// NOTE: The following import (dart:html) is only valid on web builds.
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../paint_features/color_picker_dialog.dart';
import '../paint_features/wire_painter.dart';

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

  final List<Wire> conventional = [
    Wire(
      id: 'Rc',
      points: [Offset(333, 17), Offset(289, 17), Offset(285, 344)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(79, 121), Offset(255, 121), Offset(257, 346)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(78, 177), Offset(201, 178), Offset(199, 346)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(79, 203), Offset(227, 204), Offset(230, 345)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(331, 70), Offset(135, 72), Offset(135, 345)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(332, 98), Offset(169, 97), Offset(165, 346)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [
        Offset(78, 150),
        Offset(229, 151),
        Offset(229, 181),
        Offset(320, 185),
        Offset(320, 346),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'AC Y1',
      points: [
        Offset(22, 348),
        Offset(22, 289),
        Offset(189, 291),
        Offset(191, 345),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'AC Y2',
      points: [
        Offset(50, 350),
        Offset(53, 305),
        Offset(222, 305),
        Offset(222, 346),
      ],
      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(81, 344),
        Offset(82, 316),
        Offset(312, 320),
        Offset(315, 345),
      ],
      color: Colors.grey,
    ),
  ];

  // NEW DIAGRAM WIRES (Second Column, First Row)
  final List<Wire> pek = [
    Wire(
      id: 'C',
      points: [Offset(108, 66), Offset(236, 66), Offset(235, 140)],
      color: Colors.orange,
    ),
    Wire(
      id: 'PEK+',
      points: [Offset(137, 144), Offset(225, 143), Offset(226, 154)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(311, 16), Offset(257, 18), Offset(255, 140)],
      color: Colors.red,
    ),
    Wire(
      id: 'W1',
      points: [Offset(302, 86), Offset(211, 87), Offset(211, 153)],
      color: Colors.grey,
    ),
    Wire(
      id: 'Y2',
      points: [
        Offset(136, 126),
        Offset(154, 127),
        Offset(156, 276),
        Offset(230, 279),
        Offset(232, 330),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W2',
      points: [
        Offset(302, 102),
        Offset(289, 104),
        Offset(287, 250),
        Offset(193, 252),
        Offset(192, 330),
      ],
      color: Colors.grey,
    ),
    Wire(
      id: 'PEK Y',
      points: [Offset(210, 239), Offset(212, 330)],
      color: Colors.grey,
    ),
    Wire(
      id: 'PEK W',
      points: [
        Offset(223, 239),
        Offset(222, 263),
        Offset(174, 266),
        Offset(173, 330),
      ],
      color: Colors.grey,
    ),
    Wire(
      id: 'PEK G',
      points: [
        Offset(235, 237),
        Offset(236, 275),
        Offset(247, 277),
        Offset(249, 330),
      ],

      color: Colors.grey,
    ),
    Wire(
      id: 'PEK C',
      points: [
        Offset(246, 238),
        Offset(247, 264),
        Offset(287, 265),
        Offset(288, 330),
      ],
      color: Colors.blue,
    ),
    Wire(
      id: 'PEK Y',
      points: [Offset(302, 86), Offset(211, 87), Offset(211, 153)],
      color: Colors.grey,
    ),
    Wire(
      id: 'PEK R',
      points: [
        Offset(256, 238),
        Offset(259, 277),
        Offset(266, 279),
        Offset(267, 331),
      ],
      color: Colors.grey,
    ),
    Wire(
      id: 'AC Y1',
      points: [
        Offset(100, 330),
        Offset(102, 305),
        Offset(205, 305),
        Offset(207, 332),
      ],

      color: Colors.grey,
    ),
    Wire(
      id: 'AC Y2',
      points: [
        Offset(119, 330),
        Offset(120, 291),
        Offset(226, 291),
        Offset(227, 330),
      ],

      color: Colors.grey,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(138, 330),
        Offset(140, 317),
        Offset(283, 318),
        Offset(284, 330),
      ],

      color: Colors.grey,
    ),
  ];

  final List<Wire> heatPump = [
    Wire(
      id: 'Rc',
      points: [Offset(323, 76), Offset(299, 77), Offset(298, 316)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(87, 144), Offset(275, 144), Offset(277, 316)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(87, 177), Offset(240, 178), Offset(241, 316)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(87, 194), Offset(259, 196), Offset(259, 315)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(322, 110), Offset(202, 112), Offset(202, 315)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(324, 126), Offset(220, 127), Offset(219, 316)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'O/B',
      points: [Offset(87, 228), Offset(182, 229), Offset(183, 315)],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP C',
      points: [Offset(87, 161), Offset(317, 162), Offset(318, 316)],
      color: Colors.blue,
    ),

    Wire(
      id: 'HP O/B',
      points: [
        Offset(52, 315),
        Offset(51, 304),
        Offset(177, 304),
        Offset(179, 315),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP W2',
      points: [
        Offset(71, 315),
        Offset(72, 291),
        Offset(194, 290),
        Offset(197, 315),
      ],
      color: Colors.grey,
    ),
    Wire(
      id: 'HP Y1',
      points: [
        Offset(91, 314),
        Offset(92, 277),
        Offset(233, 276),
        Offset(236, 316),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP Y2',
      points: [
        Offset(109, 315),
        Offset(111, 264),
        Offset(254, 264),
        Offset(255, 315),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP R',
      points: [
        Offset(129, 314),
        Offset(129, 251),
        Offset(293, 251),
        Offset(293, 314),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP O/B',
      points: [
        Offset(52, 315),
        Offset(51, 304),
        Offset(177, 304),
        Offset(179, 315),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP C',
      points: [
        Offset(148, 316),
        Offset(149, 237),
        Offset(312, 237),
        Offset(314, 315),
      ],
      color: Colors.blue,
    ),
  ];

  final List<Wire> dual = [
    Wire(
      id: 'Rh',
      points: [Offset(315, 95), Offset(293, 96), Offset(292, 297)],

      color: Colors.red,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(315, 77), Offset(172, 78), Offset(171, 214)],

      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(105, 95), Offset(212, 97), Offset(212, 215)],

      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(105, 132), Offset(128, 133), Offset(129, 215)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(105, 150), Offset(149, 150), Offset(150, 215)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(314, 114), Offset(250, 115), Offset(250, 297)],

      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(315, 132), Offset(272, 133), Offset(270, 297)],

      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [Offset(105, 114), Offset(191, 115), Offset(191, 214)],

      color: Colors.blue,
    ),
    Wire(
      id: 'AC Y1',
      points:  [Offset(129, 257), Offset(129, 298)],

      color: Colors.red,
    ),
    Wire(
      id: 'AC Y2',
      points:   [Offset(149, 257), Offset(150, 297)],


      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [Offset(191, 257), Offset(190, 276), Offset(171, 279), Offset(171, 298)],

      color: (Colors.grey[350])!,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Use different sets of wires for each diagram
    if (widget.diagramIndex == 0) {
      wires = List.from(conventional);
    } else if (widget.diagramIndex == 1) {
      wires = List.from(pek);
    } else if (widget.diagramIndex == 2) {
      wires = List.from(heatPump);
    } else if (widget.diagramIndex == 3) {
      wires = List.from(dual);
    }
  }

  void resetToDefault() {
    setState(() {
      if (widget.diagramIndex == 0) {
        wires = List.from(conventional);
      } else if (widget.diagramIndex == 1) {
        wires = List.from(pek);
      } else if (widget.diagramIndex == 2) {
        wires = List.from(heatPump);
      } else if (widget.diagramIndex == 3) {
        wires = List.from(dual);
      } else if (widget.diagramIndex == 4) {
        //wires = List.from(accessory);
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
    const double imageWidth = 420, imageHeight = 420;

    final String imagePath = widget.diagramIndex == 0
        ? 'assets/Smart_Thermostat_Premium_Conventional.png'
        : widget.diagramIndex == 1
        ? 'assets/Smart_Thermostat_Premium_PEK_Conventional.png'
        : widget.diagramIndex == 2
        ? 'assets/Smart_Thermostat_Premium_Heatpump.png'
        : 'assets/Smart_Thermostat_Premium_Boiler_or_Radiant_System.png';

    final String title = widget.diagramIndex == 0
        ? "Conventional Heating and Cooling Installation"
        : widget.diagramIndex == 1
        ? 'PEK Installation'
        : widget.diagramIndex == 2
        ? 'Heat Pump Installation'
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
