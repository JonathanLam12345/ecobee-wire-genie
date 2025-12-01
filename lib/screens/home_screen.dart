import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app_bar/app_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';
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
        // _buildWhatsNewItem(
        //   'V1.0.0',
        //   'Nov 27 2025',
        //   'Added the **Premium Thermostat** wiring diagrams (accessible via the dropdown). Implemented a **new Hover Dropdown menu** for better web navigation. Fixed a bug where clicking outside the dropdown didn\'t dismiss it.',
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