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

class EnhancedWiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const EnhancedWiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<EnhancedWiringDiagramWidget> createState() =>
      _PremiumWiringDiagramWidgetState();
}

class _PremiumWiringDiagramWidgetState
    extends State<EnhancedWiringDiagramWidget> {
  // Firebase Analytics instance
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // RepaintBoundary key for capturing the image + wires
  final GlobalKey _captureKey = GlobalKey();

  // Store wire ID hitboxes for rename detection
  Map<int, Rect> wireIdHitboxes = {};

  late List<Wire> wires;
  bool showWireIds = false;

  final List<Wire> conventional = [
    Wire(
      id: 'Rc',
      points: [Offset(332, 47), Offset(299, 47), Offset(297, 300)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(333, 128), Offset(265, 127), Offset(266, 300)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(81, 153), Offset(210, 155), Offset(205, 300)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(82, 183), Offset(235, 187), Offset(238, 297)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(331, 75), Offset(141, 75), Offset(139, 300)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2|O/B',
      points: [Offset(329, 103), Offset(173, 103), Offset(171, 297)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [
        Offset(81, 127),
        Offset(231, 127),
        Offset(234, 156),
        Offset(331, 160),
        Offset(331, 299),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'AC Y1',
      points: [
        Offset(19, 297),
        Offset(22, 263),
        Offset(199, 263),
        Offset(199, 297),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'AC Y2',
      points: [
        Offset(53, 300),
        Offset(54, 276),
        Offset(229, 279),
        Offset(230, 297),
      ],
      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(83, 300),
        Offset(85, 252),
        Offset(323, 252),
        Offset(326, 297),
      ],
      color: (Colors.grey[350])!,
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
      points: [Offset(107, 111), Offset(225, 112), Offset(225, 128)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(321, 16), Offset(269, 17), Offset(267, 127)],
      color: Colors.red,
    ),
    Wire(
      id: 'W1',
      points: [Offset(318, 37), Offset(206, 36), Offset(206, 125)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'Y2',
      points: [
        Offset(107, 91),
        Offset(130, 91),
        Offset(131, 292),
        Offset(229, 291),
        Offset(229, 360),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W2',
      points: [
        Offset(319, 59),
        Offset(302, 61),
        Offset(303, 256),
        Offset(175, 255),
        Offset(177, 360),
      ],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'PEK Y',
      points: [Offset(205, 237), Offset(203, 359)],
      color: (Colors.yellow),
    ),
    Wire(
      id: 'PEK W',
      points: [
        Offset(219, 239),
        Offset(218, 273),
        Offset(151, 273),
        Offset(151, 361),
      ],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'PEK G',
      points: [
        Offset(235, 237),
        Offset(235, 291),
        Offset(251, 292),
        Offset(251, 361),
      ],

      color: Colors.green,
    ),
    Wire(
      id: 'PEK C',
      points: [
        Offset(251, 237),
        Offset(251, 272),
        Offset(303, 273),
        Offset(305, 360),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'PEK R',
      points: [
        Offset(266, 237),
        Offset(265, 290),
        Offset(278, 293),
        Offset(277, 359),
      ],
      color: Colors.red,
    ),
    Wire(
      id: 'AC Y1',
      points: [
        Offset(61, 364),
        Offset(63, 332),
        Offset(192, 329),
        Offset(193, 361),
      ],

      color: Colors.red,
    ),
    Wire(
      id: 'AC Y2',
      points: [
        Offset(84, 364),
        Offset(85, 313),
        Offset(216, 315),
        Offset(219, 363),
      ],

      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(108, 363),
        Offset(108, 347),
        Offset(288, 347),
        Offset(289, 360),
      ],

      color: (Colors.grey[350])!,
    ),
  ];

  ////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> heatPump = [
    Wire(
      id: 'Rc',
      points: [Offset(353, 73), Offset(329, 73), Offset(327, 293)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(354, 136), Offset(303, 136), Offset(301, 295)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(62, 155), Offset(253, 156), Offset(254, 295)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(62, 176), Offset(281, 179), Offset(282, 291)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(351, 96), Offset(207, 96), Offset(206, 292)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2|O/B',
      points: [Offset(353, 116), Offset(183, 116), Offset(183, 292)],
      color: (Colors.grey[350])!,
    ),

    Wire(
      id: 'C',
      points: [
        Offset(61, 135),
        Offset(277, 135),
        Offset(278, 157),
        Offset(351, 161),
        Offset(353, 288),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'HP O/B',
      points: [
        Offset(18, 293),
        Offset(18, 276),
        Offset(178, 279),
        Offset(179, 296),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP W2',
      points: [
        Offset(42, 293),
        Offset(43, 265),
        Offset(205, 267),
        Offset(205, 292),
      ],
      color: Colors.grey,
    ),
    Wire(
      id: 'HP Y1',
      points: [
        Offset(66, 292),
        Offset(70, 253),
        Offset(253, 253),
        Offset(253, 291),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP Y2',
      points: [
        Offset(90, 296),
        Offset(90, 243),
        Offset(274, 241),
        Offset(277, 292),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP R',
      points: [
        Offset(114, 291),
        Offset(114, 227),
        Offset(322, 229),
        Offset(323, 292),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'HP C',
      points: [
        Offset(139, 292),
        Offset(141, 215),
        Offset(347, 217),
        Offset(350, 296),
      ],
      color: Colors.blue,
    ),
  ];
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> heatOnly = [
    Wire(
      id: 'Rc',
      points: [Offset(307, 101), Offset(210, 103), Offset(210, 232)],

      color: Colors.red,
    ),

    Wire(
      id: 'W1',
      points: [Offset(309, 138), Offset(170, 139), Offset(170, 229)],

      color: (Colors.grey[350])!,
    ),

    Wire(
      id: 'C',
      points: [Offset(103, 169), Offset(249, 169), Offset(249, 232)],

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
      wires = List.from(pek);
    } else if (widget.diagramIndex == 2) {
      wires = List.from(heatPump);
    } else if (widget.diagramIndex == 3) {
      wires = List.from(heatOnly);
    }
  }

  void resetToDefault() {
    setState(() {
      if (widget.diagramIndex == 0) {
        wires = List.from(conventional);
      } else if (widget.diagramIndex == 1) {
      } else if (widget.diagramIndex == 1) {
        wires = List.from(pek);
      } else if (widget.diagramIndex == 2) {
        wires = List.from(heatPump);
      } else if (widget.diagramIndex == 3) {
        wires = List.from(heatOnly);
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
        final title = widget.diagramIndex == 0
            ? "Conventional Installation"
            : widget.diagramIndex == 1
            ? 'PEK Installation'
            : widget.diagramIndex == 2
            ? 'Heat Pump Installation'
            : 'Heat-Only Installation';

        final title2 = title
            .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
            .replaceAll(' ', '_'); // Replace spaces with underscores

        final blob = html.Blob([pngBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement;
        anchor.href = url;

        // 3. Set the new filename using the sanitized title
        anchor.download = 'Enhanced_$title2.png';

        // Log analytics event
        await analytics.logEvent(
          name: 'enhanced_image_download',
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
        ? 'assets/Smart_Thermostat_Enhanced_Conventional.png'
        : widget.diagramIndex == 1
        ? 'assets/Smart_Thermostat-Enhanced_PEK_Conventional.png'
        : widget.diagramIndex == 2
        ? 'assets/Smart_Thermostat_Enhanced_Heatpump.png'
        : 'assets/Smart_Thermostat-Enhanced_3-wire_Heat_only.png';

    final String title = widget.diagramIndex == 0
        ? "Conventional Heating and Cooling Installation"
        : widget.diagramIndex == 1
        ? 'PEK Installation'
        : widget.diagramIndex == 2
        ? 'Heat Pump Installation'
        : 'Heat-Only Installation';

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
