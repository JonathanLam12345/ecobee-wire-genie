import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';
import '../wiring_diagrams/premium_wiring_diagram_widget.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
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
                    return
                  PremiumWiringDiagramWidget(
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
