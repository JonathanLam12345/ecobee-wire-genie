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


class EssentialWiringDiagramWidget extends StatefulWidget {
  final int diagramIndex;

  const EssentialWiringDiagramWidget({super.key, required this.diagramIndex});

  @override
  State<EssentialWiringDiagramWidget> createState() =>
      _EssentialWiringDiagramWidgetState();
}

class _EssentialWiringDiagramWidgetState
    extends State<EssentialWiringDiagramWidget> {
  // Firebase Analytics instance
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // RepaintBoundary key for capturing the image + wires
  final GlobalKey _captureKey = GlobalKey();

  // Store wire ID hitboxes for rename detection
  Map<int, Rect> wireIdHitboxes = {};

  late List<Wire> wires;
  bool showWireIds = false;
  bool _optionalWiresHidden = false; // Toggle state

  final List<Wire> conventional_ob_y2 = [

    Wire(
      id: 'Y2',
      points: [Offset(81, 205), Offset(230, 203), Offset(231, 345)],
      color: Colors.transparent,
    ),

    Wire(
      id: 'AC Y2',
      points: [
        Offset(53, 345),
        Offset(53, 308),
        Offset(224, 308),
        Offset(224, 345),
      ],
      color: Colors.transparent,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(330, 18), Offset(288, 18), Offset(288, 345)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(81, 150), Offset(258, 152), Offset(258, 345)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(81, 178), Offset(200, 178), Offset(200, 345)],
      color: Colors.yellow,
    ),

    Wire(
      id: 'W1',
      points: [Offset(81, 231), Offset(138, 232), Offset(138, 345)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [
        Offset(81, 125),
        Offset(321, 125),
        Offset(321, 345),
      ],
      color: Colors.blue,
    ),



    Wire(
      id: 'AC Y1',
      points: [
        Offset(21, 345),
        Offset(21, 295),
        Offset(194, 294),
        Offset(194, 345),
      ],
      color: Colors.red,
    ),


    Wire(
      id: 'AC C',
      points: [
        Offset(82, 345),
        Offset(82, 322),
        Offset(315, 322),
        Offset(315, 345),
      ],
      color:(Colors.grey[350])!,
    ),
  ];

  /////////////////////////////// conventional_ob_w2 //////////////
  final List<Wire> conventional_ob_w2 = [
    Wire(
      id: 'W2',
      points: [Offset(81, 204), Offset(167, 204), Offset(167, 345)],
      color: (Colors.transparent)!,
    ),
    Wire(
      id: 'Rc',
      points: [Offset(330, 18), Offset(288, 18), Offset(288, 345)],
      color: Colors.red,
    ),
    Wire(
      id: 'G',
      points: [Offset(81, 150), Offset(258, 152), Offset(258, 345)],
      color: Colors.green,
    ),
    Wire(
      id: 'Y1',
      points: [Offset(81, 178), Offset(200, 178), Offset(200, 345)],
      color: Colors.yellow,
    ),

    Wire(
      id: 'W1',
      points: [Offset(81, 231), Offset(138, 232), Offset(138, 345)],
      color: (Colors.grey[350])!,
    ),
    Wire(
      id: 'C',
      points: [
        Offset(81, 125),
        Offset(321, 125),
        Offset(321, 345),
      ],
      color: Colors.blue,
    ),



    Wire(
      id: 'AC Y1',
      points: [
        Offset(21, 345),
        Offset(21, 295),
        Offset(194, 294),
        Offset(194, 345),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'AC C',
      points: [
        Offset(82, 345),
        Offset(82, 322),
        Offset(315, 322),
        Offset(315, 345),
      ],
      color:(Colors.grey[350])!,
    ),
  ];

  /////////////////////////////////////////pek_ob_y2//////////////////////////////////////////////
  final List<Wire> pek_ob_y2 = [
    Wire(
      id: 'Y2',
      points: [Offset(98, 110), Offset(121, 110), Offset(121, 289), Offset(223, 289), Offset(223, 356)],
      color: (Colors.transparent),
    ),

    Wire(
      id: 'AC Y2',
      points: [
        Offset(75, 356),
        Offset(75, 322),
        Offset(216, 322),
        Offset(216, 356),
      ],
      color: Colors.transparent,
    ),


    Wire(
      id: 'Rc',
      points: [Offset(313, 14), Offset(256, 14), Offset(256, 123)],
      color: Colors.red,
    ),

    Wire(
      id: 'PEK',
      points: [Offset(98, 67), Offset(216, 67), Offset(216, 123)],

      color: Colors.yellow,
    ),

    Wire(
      id: 'W1',
      points: [Offset(98, 133), Offset(134, 133), Offset(134, 90), Offset(195, 90), Offset(195, 123)],
      color: (Colors.grey[350])!,
    ),


    Wire(
      id: 'C',
      points: [
        Offset(98, 45),
        Offset(236, 45),
        Offset(236, 123),
      ],
      color: Colors.green,
    ),
    Wire(
      id: 'AC Y1',
      points: [
        Offset(49, 356),
        Offset(49, 308),
        Offset(190, 308),
        Offset(190, 356),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'AC C',
      points: [
        Offset(99, 356),
        Offset(99, 340),
        Offset(291, 341),
        Offset(291, 356),
      ],
      color: (Colors.grey[350])!,
    ),


    Wire(
      id: 'PEK Y',
      points: [
        Offset(195, 239),
        Offset(195, 356),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'PEK W',
      points: [
        Offset(211, 239),
        Offset(211, 270),
        Offset(146, 271),
        Offset(146, 356),
      ],
      color: (Colors.grey[350])!,
    ),

    Wire(
      id: 'PEK G',
      points: [
        Offset(227, 239),
        Offset(227, 289),
        Offset(245, 289),
        Offset(245, 356),
      ],
      color: Colors.green,
    ),

    Wire(
      id: 'PEK C',
      points: [
        Offset(242, 239),
        Offset(242, 272),
        Offset(298, 272),
        Offset(298, 356),
      ],
      color: Colors.blue,
    ),



    Wire(
      id: 'PEK R',
      points: [
        Offset(256, 239),
        Offset(257, 289),
        Offset(270, 289),
        Offset(270, 356),
      ],
      color: Colors.red,
    ),

  ];

  /////////////////////////////////////////pek_ob_w2//////////////////////////////////////////////
  final List<Wire> pek_ob_w2 = [
    Wire(
      id: 'W2',
      points: [Offset(98, 110), Offset(121, 110), Offset(121, 290), Offset(168, 290), Offset(169, 356)],
      color: (Colors.transparent),
    ),


    Wire(
      id: 'Rc',
      points: [Offset(313, 14), Offset(256, 14), Offset(256, 123)],
      color: Colors.red,
    ),

    Wire(
      id: 'PEK',
      points: [Offset(98, 67), Offset(216, 67), Offset(216, 123)],

      color: Colors.yellow,
    ),

    Wire(
      id: 'W1',
      points: [Offset(98, 133), Offset(134, 133), Offset(134, 90), Offset(195, 90), Offset(195, 123)],
      color: (Colors.grey[350])!,
    ),


    Wire(
      id: 'C',
      points: [
        Offset(98, 45),
        Offset(236, 45),
        Offset(236, 123),
      ],
      color: Colors.green,
    ),
    Wire(
      id: 'AC Y1',
      points: [
        Offset(49, 356),
        Offset(49, 308),
        Offset(190, 308),
        Offset(190, 356),
      ],
      color: Colors.red,
    ),

    Wire(
      id: 'AC C',
      points: [
        Offset(99, 356),
        Offset(99, 340),
        Offset(291, 341),
        Offset(291, 356),
      ],
      color: (Colors.grey[350])!,
    ),


    Wire(
      id: 'PEK Y',
      points: [
        Offset(195, 239),
        Offset(195, 356),
      ],
      color: Colors.yellow,
    ),
    Wire(
      id: 'PEK W',
      points: [
        Offset(211, 239),
        Offset(211, 270),
        Offset(146, 271),
        Offset(146, 356),
      ],
      color: (Colors.grey[350])!,
    ),

    Wire(
      id: 'PEK G',
      points: [
        Offset(227, 239),
        Offset(227, 289),
        Offset(245, 289),
        Offset(245, 356),
      ],
      color: Colors.green,
    ),

    Wire(
      id: 'PEK C',
      points: [
        Offset(242, 239),
        Offset(242, 272),
        Offset(298, 272),
        Offset(298, 356),
      ],
      color: Colors.blue,
    ),



    Wire(
      id: 'PEK R',
      points: [
        Offset(256, 239),
        Offset(257, 289),
        Offset(270, 289),
        Offset(270, 356),
      ],
      color: Colors.red,
    ),

  ];



  //////////////////////////////////////////////heat pump///////////////////////////////////////////////////////////////////////////////////////////////////
  final List<Wire> heatPump = [
    Wire(
      id: 'Rc',
      points: [Offset(351, 52), Offset(321, 52), Offset(322, 321)],

      color: Colors.red,
    ),

    Wire(
      id: 'C',
      points: [Offset(66, 129), Offset(346, 129), Offset(346, 321)],
      color: Colors.blue,
    ),

    Wire(
      id: 'G',
      points: [Offset(66, 149), Offset(295, 149), Offset(295, 321)],
      color: (Colors.green)!,
    ),

    Wire(
      id: 'Y1',
      points: [Offset(66, 170), Offset(274, 170), Offset(274, 321)],
      color: (Colors.yellow)!,
    ),

    Wire(
      id: 'O/B*',
      points: [Offset(66, 191), Offset(227, 191), Offset(227, 321)],
      color: (Colors.orange)!,
    ),
    Wire(
      id: 'W1',
      points: [Offset(66, 212), Offset(248, 212), Offset(248, 321)],
      color:  (Colors.grey[350])!,
    ),

    Wire(
      id: 'W1',
      points: [Offset(66, 212), Offset(248, 212), Offset(248, 321)],
      color:  (Colors.grey[350])!,
    ),

    Wire(
      id: 'O/B',
      points: [Offset(67, 321), Offset(67, 276), Offset(221, 276), Offset(221, 321)],
      color:  (Colors.orange)!,
    ),
    Wire(
      id: 'O/B Y1',
      points: [Offset(90, 321), Offset(90, 260), Offset(268, 260), Offset(268, 321)],
      color:  (Colors.yellow)!,
    ),
    Wire(
      id: 'O/B R',
      points: [Offset(114, 321), Offset(114, 243), Offset(316, 243), Offset(316, 321)],
      color:  (Colors.red)!,
    ),
    Wire(
      id: 'O/B C',
      points: [Offset(138, 321), Offset(137, 227), Offset(339, 227), Offset(339, 321)],
      color:  (Colors.blue)!,
    ),

  ];

  @override
  void initState() {
    super.initState();
    // Use different sets of wires for each diagram
    if (widget.diagramIndex == 0) {
      wires = List.from(conventional_ob_y2);
    } else if (widget.diagramIndex == 1) {
      wires = List.from(conventional_ob_w2);
    } else if (widget.diagramIndex == 2) {
      wires = List.from(pek_ob_y2);
    } else if (widget.diagramIndex == 3) {
      wires = List.from(pek_ob_w2);
    }
    else if (widget.diagramIndex == 4) {
      wires = List.from(heatPump);
    }
  }

  void resetToDefault() {
    setState(() {
      if (widget.diagramIndex == 0) {
        wires = List.from(conventional_ob_y2);
      } else if (widget.diagramIndex == 1) {
        wires = List.from(conventional_ob_w2);
      } else if (widget.diagramIndex == 2) {
        wires = List.from(pek_ob_y2);
      } else if (widget.diagramIndex == 3) {
        wires = List.from(pek_ob_w2);
      } else if (widget.diagramIndex == 4) {
        wires = List.from(heatPump);
      }
      showWireIds = false;
      _optionalWiresHidden = false;
    });
  }

  void toggleWireIds() => setState(() => showWireIds = !showWireIds);

  void toggleOptionalWires() {
    setState(() {
      _optionalWiresHidden = !_optionalWiresHidden;
      wires = wires.map((wire) {
        if (wire.id == 'Y2') {
          return wire.copyWith(color: _optionalWiresHidden ? Colors.white : Colors.transparent);
        }
        if (wire.id == 'W2') {
          return wire.copyWith(color: _optionalWiresHidden ? Colors.white : Colors.transparent);
        }
        if (wire.id == 'AC Y2') {
          return wire.copyWith(color: _optionalWiresHidden ? Colors.white : Colors.transparent);
        }
        if (wire.id == 'HP Y2') {
          return wire.copyWith(color: _optionalWiresHidden ? Colors.white : Colors.transparent);
        }
        return wire;
      }).toList();
    });
  }



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
            ? "Conventional with Y2"

        : widget.diagramIndex == 1
    ? 'Conventional with W2'
        : widget.diagramIndex == 2
    ? 'PEK with Y2'
        : widget.diagramIndex == 3
    ?  'PEK with W2'
        : widget.diagramIndex == 4
    ? 'Heat Pump':'Heat Pump'
    ;
        final title2 = title
            .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
            .replaceAll(' ', '_'); // Replace spaces with underscores

        final blob = html.Blob([pngBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement;
        anchor.href = url;

        // 3. Set the new filename using the sanitized title
        anchor.download = 'Essential_$title2.png';

        // Log analytics event
        await analytics.logEvent(
          name: 'Essential_$title2.png',
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
        ? 'assets/Essential_Conventional_with_Y2.png'
        : widget.diagramIndex == 1
        ? 'assets/Essential_Conventional_with_W2.png'
        : widget.diagramIndex == 2
        ? 'assets/Essential_Conventional_Pek_with_Y2.png'
        : widget.diagramIndex == 3
        ? 'assets/Essential_Conventional_Pek_with_W2.png'
    : widget.diagramIndex == 4
   ? 'Essential_Heat_Pump.png':'Essential_Heat_Pump.png';

    final String title = widget.diagramIndex == 0
        ? "Conventional Heating and Cooling Installation\n(O/B* used as Y2)"
        : widget.diagramIndex == 1
        ? "Conventional Heating and Cooling Installation\n(O/B* used as W2)"
        : widget.diagramIndex == 2
        ? 'Convectional PEK Installation\n(O/B* used as Y2)'
        : widget.diagramIndex == 3
        ? 'Convectional PEK Installation\n(O/B* used as W2)'
        : widget.diagramIndex == 4
        ? 'Heat Pump Installation':'Heat Pump Installation'
    ;

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
                  icon: Icon(_optionalWiresHidden ? Icons.visibility : Icons.visibility_off),
                  label: Text(_optionalWiresHidden ? "SHOW OPTIONAL WIRE" : " HIDE OPTIONAL WIRE "),
                  style: ElevatedButton.styleFrom(backgroundColor: _optionalWiresHidden ? Colors.grey : Colors.redAccent[100]),
                  onPressed: toggleOptionalWires,
                ),

                ElevatedButton.icon(
                  icon: Icon(
                    showWireIds ? Icons.visibility : Icons.visibility_off,
                  ),
                  label: Text(showWireIds ? " Hide Wire IDs " : "Show Wire IDs"),
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
