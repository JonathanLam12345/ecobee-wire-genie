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
      IconData icon, String title, String description) {
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
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(description, style: const TextStyle(fontSize: 16)),
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
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          SelectableText(
            changes,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Widget for the left column content: How to Use the Diagram Editor
  Widget _buildHowToUseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText(
          'How to Use the Diagram Editor',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // _buildInstructionStep(
        //   Icons.gesture,
        //   'Select a Diagram',
        //   "Use the **'Thermostat' dropdown** in the top navigation bar to choose a specific thermostat model (e.g., 'Premium') and view its associated wiring diagrams.",
        // ),
        // _buildInstructionStep(
        //   Icons.color_lens,
        //   'Change Wire Color',
        //   '**Click directly on any wire** in the schematic to open a color picker and change its color to match your physical installation.',
        // ),
        // _buildInstructionStep(
        //   Icons.edit,
        //   'Rename Wire ID',
        //   '**Toggle "Show Wire IDs"** on, then **click on the white wire ID label** (e.g., Rc, Y1) to rename it. This helps match the labels in your home.',
        // ),
        // _buildInstructionStep(
        //   Icons.save,
        //   'Save Your Custom Diagram',
        //   'Click the **"Save Image"** button to download a PNG image of the schematic, including your custom wire colors and labels, and then send it off to the Smart Owner.',
        // ),
      ],
    );
  }

  // Widget for the right column content: What's New in V1.1.0
  Widget _buildWhatsNewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText(
          "What's New in V1.1.0",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // _buildWhatsNewItem(
        //   'V1.0.0',
        //   'Nov 27 2025',
        //   'Added the **Premium Thermostat** wiring diagrams (accessible via the dropdown). Implemented a **new Hover Dropdown menu** for better web navigation. Fixed a bug where clicking outside the dropdown didn\'t dismiss it.',
        // ),
        // _buildWhatsNewItem(
        //   'V1.0.0',
        //   'Oct 2025',
        //   'Initial release with support for Conventional Heating and Cooling wiring diagrams. Features include wire color/ID editing and image saving.',
        // ),
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

          // Use Stack to place the version text absolutely
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
                          // Large welcome text only appears once at the top
                          const SelectableText(
                            'Welcome to the WireGenie!',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF172538)),
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
                                  padding: const EdgeInsets.only(right: 48.0),
                                  child: _buildHowToUseSection(),
                                ),
                              ),

                              // Vertical Divider
                              const SizedBox(
                                height: 450,
                                child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Colors.black12),
                              ),

                              // Right Column: What's New
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 48.0),
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

              // *** ADDED: Positioned Widget for App Version in Top Right Corner ***
              Positioned(
                top: 8.0,
                right: 32.0, // Match the padding of the SingleChildScrollView
                child: SelectableText(
                  _version,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
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