import 'package:flutter/material.dart';

import '../app_bar/app_navigation_bar.dart';
import '../wiring_diagrams/enhanced_wiring_diagram_widget.dart';
class EnhancedScreen extends StatelessWidget {
  const EnhancedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int diagramIndexToShow = 1;

    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),
      appBar: const AppNavigationBar(showBackButton: false),
      body: SelectableRegion(
        selectionControls: MaterialTextSelectionControls(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: EnhancedWiringDiagramWidget(
                key: const ValueKey('EnhancedDiagram'),
                diagramIndex: diagramIndexToShow,
              ),
            ),
          ),
        ),
      ),
    );
  }
}