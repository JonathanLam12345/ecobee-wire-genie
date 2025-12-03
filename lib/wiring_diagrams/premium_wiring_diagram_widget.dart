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

class PremiumWiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const PremiumWiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<PremiumWiringDiagramWidget> createState() =>
      _PremiumWiringDiagramWidgetState();
}

class _PremiumWiringDiagramWidgetState
    extends State<PremiumWiringDiagramWidget> {
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
      points: [Offset(333, 17), Offset(289, 17), Offset(289, 346)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(83, 124), Offset(258, 124), Offset(258, 346)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(83, 177), Offset(201, 178), Offset(200, 346)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(83, 203), Offset(231, 204), Offset(231, 346)],
      color: Colors.transparent,
    ),
    Wire(
      id: 'W1',
      points: [Offset(331, 71), Offset(137, 72), Offset(137, 346)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(332, 98), Offset(167, 98), Offset(167, 346)],
      color: (Colors.transparent)!,
    ),
    Wire(
      id: 'C',
      points: [
        Offset(83, 151),
        Offset(230, 151),
        Offset(230, 184),
        Offset(321, 184),
        Offset(321, 346),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'AC Y1',
      points: [
        Offset(22, 346),
        Offset(22, 294),
        Offset(194, 294),
        Offset(194, 346),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'AC Y2',
      points: [
        Offset(52, 346),
        Offset(52, 306),
        Offset(224, 306),
        Offset(224, 346),
      ],
      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(83, 346),
        Offset(83, 322),
        Offset(315, 322),
        Offset(315, 346),
      ],
      color: (Colors.grey[350])!,
    ),
  ];

  // NEW DIAGRAM WIRES (Second Column, First Row)
  final List<Wire> pek = [
    Wire(
      id: 'Rc',
      points: [Offset(311, 16), Offset(257, 16), Offset(257, 139)],
      color: Colors.red,
    ),
    Wire(
      id: 'C',
      points: [Offset(108, 66), Offset(236, 66), Offset(236, 139)],
      color: Colors.orange,
    ),
    Wire(
      id: 'PEK+',
      points: [Offset(108, 128), Offset(217, 128), Offset(217, 139)],
      color: Colors.yellow,
    ),

    Wire(
      id: 'W1',
      points: [Offset(312, 57), Offset(197, 57), Offset(199, 140)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'Y2',
      points: [
        Offset(108, 107),
        Offset(129, 107),
        Offset(129, 296),
        Offset(225, 296),
        Offset(225, 361),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W2',
      points: [
        Offset(310, 78),
        Offset(295, 78),
        Offset(295, 263),
        Offset(176, 263),
        Offset(176, 361),
      ],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'PEK Y',
      points: [Offset(199, 245), Offset(199, 361)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'PEK W',
      points: [
        Offset(213, 247),
        Offset(215, 280),
        Offset(152, 280),
        Offset(152, 363),
      ],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'PEK G',
      points: [
        Offset(229, 249),
        Offset(228, 297),
        Offset(245, 297),
        Offset(245, 361),
      ],

      color: Colors.green,
    ),
    Wire(
      id: 'PEK C',
      points: [
        Offset(243, 249),
        Offset(243, 279),
        Offset(296, 279),
        Offset(296, 361),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'PEK R',
      points: [
        Offset(255, 249),
        Offset(255, 296),
        Offset(269, 296),
        Offset(269, 361),
      ],
      color: Colors.red,
    ),
    Wire(
      id: 'AC Y1',
      points: [
        Offset(61, 361),
        Offset(61, 331),
        Offset(192, 331),
        Offset(192, 361),
      ],

      color: Colors.red,
    ),
    Wire(
      id: 'AC Y2',
      points: [
        Offset(84, 361),
        Offset(85, 313),
        Offset(218, 313),
        Offset(218, 361),
      ],

      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(108, 361),
        Offset(108, 347),
        Offset(289, 347),
        Offset(289, 361),
      ],

      color: (Colors.grey[350])!,
    ),
  ];

  ////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> heatPump = [
    Wire(
      id: 'Rc',
      points: [Offset(353, 31), Offset(321, 31), Offset(323, 326)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(61, 115), Offset(293, 113), Offset(296, 326)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(63, 156), Offset(251, 156), Offset(251, 326)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(63, 177), Offset(273, 179), Offset(273, 326)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(352, 73), Offset(203, 73), Offset(203, 328)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(352, 93), Offset(223, 92), Offset(223, 327)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'O/B',
      points: [Offset(61, 219), Offset(177, 219), Offset(179, 326)],
      color: Colors.orange,
    ),
    Wire(
      id: 'C',
      points: [Offset(61, 136), Offset(348, 136), Offset(348, 326)],
      color: Colors.blue,
    ),

    Wire(
      id: 'HP O/B',
      points: [
        Offset(16, 326),
        Offset(16, 313),
        Offset(173, 313),
        Offset(173, 326),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP W2',
      points: [
        Offset(39, 326),
        Offset(39, 296),
        Offset(197, 296),
        Offset(197, 326),
      ],
      color: Colors.grey,
    ),
    Wire(
      id: 'HP Y1',
      points: [
        Offset(64, 326),
        Offset(64, 280),
        Offset(243, 280),
        Offset(244, 326),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP Y2',
      points: [
        Offset(88, 325),
        Offset(87, 263),
        Offset(268, 263),
        Offset(269, 325),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP R',
      points: [
        Offset(111, 326),
        Offset(112, 247),
        Offset(315, 247),
        Offset(315, 326),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'HP C',
      points: [
        Offset(135, 326),
        Offset(136, 231),
        Offset(340, 229),
        Offset(340, 326),
      ],
      color: Colors.blue,
    ),
  ];

  /////////////////////////////////////////DUAL////////////////////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> dual = [
    Wire(
      id: 'Rh',
      points: [Offset(343, 72), Offset(315, 72), Offset(315, 336)],

      color: Colors.red,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(343, 49), Offset(155, 49), Offset(155, 229)],

      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(71, 73), Offset(209, 73), Offset(211, 228)],

      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(72, 121), Offset(101, 121), Offset(101, 227)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(72, 145), Offset(128, 144), Offset(129, 228)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(343, 97), Offset(259, 97), Offset(259, 336)],

      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(345, 121), Offset(287, 121), Offset(287, 336)],

      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [Offset(72, 97), Offset(183, 97), Offset(183, 228)],

      color: Colors.blue,
    ),
    Wire(
      id: 'AC Y1',
      points: [Offset(100, 287), Offset(100, 336)],

      color: Colors.red,
    ),
    Wire(
      id: 'AC Y2',
      points: [Offset(127, 285), Offset(127, 336)],

      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(183, 286),
        Offset(183, 312),
        Offset(156, 312),
        Offset(156, 336),
      ],

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
            onPressed: () {
              return Navigator.pop(context, controller.text.trim());
            },
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
            : 'Dual Transformer Installation';

        final title2 = title
            .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
            .replaceAll(' ', '_'); // Replace spaces with underscores

        final blob = html.Blob([pngBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement;
        anchor.href = url;

        anchor.download = 'Premium_$title2.png';

        // Log analytics event
        await analytics.logEvent(
          name: 'premium_image_download',
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
