import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app_bar/app_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _version = "Loading version...";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = "App Version: ${info.version}";
    });
  }

  Widget _buildInstructionStep(
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsNewItem(String version, String date, String changes) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            '$version ($date)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SelectableText(changes, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHowToUseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText(
          'How to Use WireGenie',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildInstructionStep(
          Icons.gesture,
          "Select a Diagram:",
          "Use the top navigation bar to choose a specific thermostat model (e.g., 'Premium') and view its associated wiring diagrams.",
        ),
        _buildInstructionStep(
          Icons.color_lens,
          "Change Wire Color:",
          "Click directly on any wire in the schematic to open a color picker and change its color to match Smart Owner's setup.",
        ),
        _buildInstructionStep(
          Icons.edit,
          "Rename Wire ID:",
          "Toggle \"Show Wire IDs\" button on, then click on the grey wire ID label (e.g., Rc, Y1) to rename it. This helps match the labels for Smart Owner's setup.",
        ),
        _buildInstructionStep(
          Icons.save,
          "Save Your Custom Diagram:",
          "Click the \"Save Image\" button to download a PNG image of the schematic, including your custom wire colors and labels, and then send it off to the Smart Owner.",
        ),
      ],
    );
  }

  Widget _buildWhatsNewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText(
          "What's New in V1.1.0",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Add latest version info at the top here, and not at the bottom.
        _buildWhatsNewItem('V1.0.0', 'December 3, 2025', 'Initial Release'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the screen is wide enough for the two-column layout
    return LayoutBuilder(
      builder: (context, constraints) {
        // Threshold for switching to two-column layout
        final bool isWide = constraints.maxWidth > 800;

        return Scaffold(
          backgroundColor: const Color(0xFFf9fafc),
          // *** USING REUSABLE APP BAR ***
          appBar: const AppNavigationBar(showBackButton: false),

          body: Stack(
            children: [
              SelectableRegion(
                selectionControls: MaterialTextSelectionControls(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: ConstrainedBox(
                      // Max width for the content container
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                width: 140,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Center(
                                  child: SelectableText(
                                    'Welcome to the WireGenie!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF172538),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),

                          // Row/Column switch for two-column effect
                          isWide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left Column: How to Use
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 48.0,
                                        ),
                                        child: _buildHowToUseSection(),
                                      ),
                                    ),

                                    // Vertical Divider
                                    const SizedBox(
                                      height: 450,
                                      child: VerticalDivider(
                                        width: 1,
                                        thickness: 1,
                                        color: Colors.black12,
                                      ),
                                    ),

                                    // Right Column: What's New
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 48.0,
                                        ),
                                        child: _buildWhatsNewSection(),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  // Fallback single-column for narrow screens
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildHowToUseSection(),
                                    const Divider(height: 48, thickness: 1),
                                    _buildWhatsNewSection(),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 8.0,
                right: 32.0, // Match the padding of the SingleChildScrollView
                child: SelectableText(
                  _version,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              // *** END ADDITION ***
            ],
          ),
        );
      },
    );
  }
}
