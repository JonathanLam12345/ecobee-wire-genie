import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';
import '../wiring_diagrams/ecobee3_wiring_diagram_widget.dart';


class Ecobee3Screen extends StatefulWidget {
  const Ecobee3Screen({super.key});

  @override
  State<Ecobee3Screen> createState() => _Ecobee3ScreenState();
}

class _Ecobee3ScreenState extends State<Ecobee3Screen> {
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
                      Ecobee3WiringDiagramWidget(
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

