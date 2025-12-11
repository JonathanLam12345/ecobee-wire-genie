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

/*

As you can see, here is a wiring diagram.
 I would like to get the exact pixel coordinates of all of the vertices of the wires.
 My goal is to paint over the wires linearly, so that's why I need the wiring coordinates.

 So, a single line would have 2 sets of coordinates.
 The top left corner is the (0,0) coordinate.

 For example,
the R wire will be something like: points: [Offset(0, 1), Offset(2, 4), Offset(22, 98)],

 */


class EnhancedWiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const EnhancedWiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<EnhancedWiringDiagramWidget> createState() =>
      _EnhancedWiringDiagramWidgetState();
}

class _EnhancedWiringDiagramWidgetState
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
      points: [Offset(331, 47), Offset(298, 47), Offset(298, 298)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(331, 128), Offset(267, 127), Offset(267, 298)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(83, 153), Offset(206, 153), Offset(206, 298)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(83, 183), Offset(238, 183), Offset(238, 298)],
      color: Colors.transparent,
    ),
    Wire(
      id: 'W1',
      points: [Offset(331, 75), Offset(141, 75), Offset(139, 298)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2|O/B',
      points: [Offset(331, 103), Offset(172, 103), Offset(172, 298)],
      color: (Colors.transparent)!,
    ),
    Wire(
      id: 'C',
      points: [
        Offset(83, 127),
        Offset(236, 127),
        Offset(236, 159),
        Offset(331, 159),
        Offset(331, 298),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'AC Y1',
      points: [
        Offset(20, 297),
        Offset(20, 263),
        Offset(199, 263),
        Offset(199, 297),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'AC Y2',
      points: [
        Offset(53, 297),
        Offset(53, 278),
        Offset(230, 278),
        Offset(230, 297),
      ],
      color: Colors.transparent,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(83, 296),
        Offset(83, 250),
        Offset(326, 250),
        Offset(326, 298),
      ],
      color: (Colors.grey[350])!,
    ),
  ];

  ////////////////////////////////PEK/////////////////
  final List<Wire> pek = [
    Wire(
      id: 'Rc',
      points: [Offset(318, 16), Offset(268, 16), Offset(268, 124)],
      color: Colors.red,
    ),
    Wire(
      id: 'C',
      points: [Offset(110, 49), Offset(246, 49), Offset(246, 124)],
      color: Colors.green,
    ),
    Wire(
      id: 'PEK+',
      points: [Offset(110, 111), Offset(226, 112), Offset(226, 124)],
      color: Colors.yellow,
    ),

    Wire(
      id: 'W1',
      points: [Offset(318, 37), Offset(206, 36), Offset(206, 124)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'Y2',
      points: [
        Offset(110, 91),
        Offset(132, 91),
        Offset(132, 292),
        Offset(231, 291),
        Offset(231, 358),
      ],
      color: Colors.transparent,
    ),
    Wire(
      id: 'W2|O/B',
      points: [
        Offset(317, 59),
        Offset(304, 59),
        Offset(304, 256),
        Offset(177, 255),
        Offset(177, 358),
      ],
      color: (Colors.transparent)!,
    ),
    Wire(
      id: 'PEK Y',
      points: [Offset(205, 240), Offset(205, 358)],
      color: (Colors.yellow),
    ),
    Wire(
      id: 'PEK W',
      points: [
        Offset(220, 240),
        Offset(220, 273),
        Offset(152, 273),
        Offset(152, 358),
      ],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'PEK G',
      points: [
        Offset(236, 240),
        Offset(236, 292),
        Offset(252, 292),
        Offset(252, 358),
      ],

      color: Colors.green,
    ),
    Wire(
      id: 'PEK C',
      points: [
        Offset(252, 240),
        Offset(252, 272),
        Offset(305, 273),
        Offset(305, 358),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'PEK R',
      points: [
        Offset(266, 240),
        Offset(266, 290),
        Offset(278, 290),
        Offset(278, 358),
      ],
      color: Colors.red,
    ),
    Wire(
      id: 'AC Y1',
      points: [
        Offset(59, 358),
        Offset(59, 327),
        Offset(199, 327),
        Offset(199, 358),
      ],

      color: Colors.red,
    ),
    Wire(
      id: 'AC Y2',
      points: [
        Offset(84, 358),
        Offset(85, 309),
        Offset(226, 309),
        Offset(226, 358),
      ],

      color: Colors.transparent,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(109, 358),
        Offset(109, 343),
        Offset(299, 343),
        Offset(299, 358),
      ],

      color: (Colors.grey[350])!,
    ),
  ];

  //////////////////////////////////////////HEAT PUMP//////////////////////////////////////////////
  final List<Wire> heatPump = [


    Wire(
      id: 'Rc',
      points: [Offset(350, 73), Offset(328, 73), Offset(328, 289)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(350, 136), Offset(302, 136), Offset(302, 289)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(64, 155), Offset(256, 156), Offset(256, 289)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(64, 178), Offset(281, 178), Offset(282, 289)],

      color: Colors.transparent,
    ),
    Wire(
      id: 'W1',
      points: [Offset(350, 96), Offset(209, 96), Offset(209, 289)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2|O/B',
      points: [Offset(350, 116), Offset(183, 116), Offset(183, 289)],
      color: (Colors.orange)!,
    ),

    Wire(
      id: 'C',
      points: [
        Offset(64, 134),
        Offset(279, 134),
        Offset(279, 159),
        Offset(352, 159),
        Offset(352, 290),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'HP O/B',
      points: [
        Offset(18, 289),
        Offset(18, 276),
        Offset(179, 276),
        Offset(179, 289),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP W2',
      points: [
        Offset(43, 289),
        Offset(43, 265),
        Offset(205, 265),
        Offset(205, 289),
      ],
      color: (Colors.grey[350])!,
    ),

    Wire(
      id: 'HP Y1',
      points: [
        Offset(66, 289),
        Offset(66, 253),
        Offset(253, 253),
        Offset(253, 289),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP Y2',
      points: [
        Offset(91, 289),
        Offset(91, 241),
        Offset(277, 241),
        Offset(277, 289),
      ],
      color: Colors.transparent,
    ),
    Wire(
      id: 'HP R',
      points: [
        Offset(115, 289),
        Offset(115, 227),
        Offset(324, 227),
        Offset(324, 289),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'HP C',
      points: [
        Offset(139, 289),
        Offset(139, 214),
        Offset(349, 214),
        Offset(349, 289),
      ],
      color: Colors.blue,
    ),
  ];
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> heatOnly = [
    Wire(
      id: 'Rc',
      points: [Offset(307, 101), Offset(209, 101), Offset(209, 230)],

      color: Colors.red,
    ),

    Wire(
      id: 'W1',
      points: [Offset(307, 138), Offset(169, 138), Offset(169, 230)],

      color: (Colors.grey[350])!,
    ),

    Wire(
      id: 'C',
      points: [Offset(102, 170), Offset(250, 170), Offset(250, 230)],

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

  bool _isPointNearLine(Offset p, Offset a, Offset b, {double tolerance = 5}) {
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
          name: 'enhanced_$title2.png',
          // parameters: {
          //   'diagram_title': title2,
          //   'diagram_index': widget.diagramIndex,
          // },
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
