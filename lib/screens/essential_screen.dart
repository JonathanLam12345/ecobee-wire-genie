import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';
import '../wiring_diagrams/enhanced_wiring_diagram_widget.dart';
import '../wiring_diagrams/essential_wiring_diagram_widget.dart';

class EssentialScreen extends StatefulWidget {
  const EssentialScreen({super.key});

  @override
  State<EssentialScreen> createState() => _EssentialScreenState();
}

class _EssentialScreenState extends State<EssentialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),

      appBar: const AppNavigationBar(showBackButton: false),

      body: SelectableRegion(
        selectionControls: MaterialTextSelectionControls(),

        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: List.generate(5, (index) {
                  //return SizedBox.shrink();
                  return
                    EssentialWiringDiagramWidget(
                      key: GlobalKey(), // unique key per instance
                      diagramIndex: index,
                    );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
