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
      points: [Offset(105, 128), Offset(217, 128), Offset(216, 140)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(311, 16), Offset(257, 18), Offset(255, 140)],
      color: Colors.red,
    ),
    Wire(
      id: 'W1',
      points: [Offset(312, 57), Offset(197, 57), Offset(199, 141)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'Y2',
      points: [
        Offset(105, 106),
        Offset(128, 107),
        Offset(128, 294),
        Offset(220, 299),
        Offset(223, 363),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W2',
      points: [
        Offset(311, 78),
        Offset(295, 78),
        Offset(295, 263),
        Offset(176, 264),
        Offset(175, 361),
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
        Offset(229, 248),
        Offset(228, 296),
        Offset(243, 297),
        Offset(245, 363),
      ],

      color: Colors.green,
    ),
    Wire(
      id: 'PEK C',
      points: [
        Offset(243, 247),
        Offset(243, 279),
        Offset(295, 281),
        Offset(295, 361),
      ],
      color: Colors.blue,
    ),

    Wire(
      id: 'PEK R',
      points: [
        Offset(255, 247),
        Offset(257, 296),
        Offset(269, 299),
        Offset(269, 365),
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
      points: [Offset(353, 31), Offset(321, 31), Offset(323, 327)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(61, 115), Offset(293, 113), Offset(296, 327)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(63, 156), Offset(251, 156), Offset(251, 327)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(63, 177), Offset(273, 179), Offset(273, 328)],

      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(352, 73), Offset(203, 73), Offset(203, 328)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(353, 93), Offset(223, 92), Offset(223, 327)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'O/B',
      points: [Offset(61, 219), Offset(177, 219), Offset(179, 328)],
      color: Colors.orange,
    ),
    Wire(
      id: 'C',
      points: [Offset(61, 136), Offset(345, 136), Offset(348, 327)],
      color: Colors.blue,
    ),

    Wire(
      id: 'HP O/B',
      points: [
        Offset(16, 328),
        Offset(15, 313),
        Offset(173, 313),
        Offset(173, 328),
      ],
      color: Colors.orange,
    ),
    Wire(
      id: 'HP W2',
      points: [
        Offset(39, 328),
        Offset(39, 296),
        Offset(197, 296),
        Offset(196, 327),
      ],
      color: Colors.grey,
    ),
    Wire(
      id: 'HP Y1',
      points: [
        Offset(64, 328),
        Offset(64, 280),
        Offset(243, 280),
        Offset(244, 325),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP Y2',
      points: [
        Offset(88, 329),
        Offset(87, 261),
        Offset(268, 261),
        Offset(269, 325),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'HP R',
      points: [
        Offset(111, 328),
        Offset(112, 247),
        Offset(312, 247),
        Offset(313, 329),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'HP C',
      points: [
        Offset(135, 328),
        Offset(136, 231),
        Offset(340, 229),
        Offset(340, 327),
      ],
      color: Colors.blue,
    ),
  ];
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> dual = [
    Wire(
      id: 'Rh',
      points: [Offset(345, 73), Offset(315, 72), Offset(315, 337)],

      color: Colors.red,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(345, 49), Offset(155, 51), Offset(155, 231)],

      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(71, 73), Offset(209, 73), Offset(211, 228)],

      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(72, 120), Offset(100, 123), Offset(100, 229)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'Y2',
      points: [Offset(72, 145), Offset(128, 144), Offset(129, 231)],
      color: Colors.yellow,
    ),
    Wire(
      id: 'W1',
      points: [Offset(343, 97), Offset(259, 99), Offset(259, 337)],

      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'W2',
      points: [Offset(345, 121), Offset(287, 121), Offset(288, 336)],

      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [Offset(72, 97), Offset(180, 99), Offset(184, 228)],

      color: Colors.blue,
    ),
    Wire(
      id: 'AC Y1',
      points: [Offset(100, 287), Offset(100, 337)],

      color: Colors.red,
    ),
    Wire(
      id: 'AC Y2',
      points: [Offset(128, 285), Offset(127, 335)],

      color: Colors.red,
    ),
    Wire(
      id: 'AC C',
      points: [
        Offset(183, 287),
        Offset(183, 312),
        Offset(156, 312),
        Offset(155, 337),
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
            : 'Dual Transformer Installation';

        final title2 = title
            .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
            .replaceAll(' ', '_'); // Replace spaces with underscores

        final blob = html.Blob([pngBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement;
        anchor.href = url;

        // 3. Set the new filename using the sanitized title
        anchor.download =
        'Premium_$title2.png';


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