import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';
import '../wiring_diagrams/doorbell_wiring_diagram_widget.dart';
import '../wiring_diagrams/premium_wiring_diagram_widget.dart';

class DoorbellScreen extends StatefulWidget {
  const DoorbellScreen({super.key});

  @override
  State<DoorbellScreen> createState() => _DoorbellScreenState();
}

class _DoorbellScreenState extends State<DoorbellScreen> {
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
                children: List.generate(4, (index) {
                  //return SizedBox.shrink();
                  return DoorbellWiringDiagramWidget(
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
