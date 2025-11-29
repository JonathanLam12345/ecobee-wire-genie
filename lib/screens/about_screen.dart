import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final List<String> teamMembers = const [
    'Jonathan Lam (Main Lead Developer)',
    'Shoeib MohamadiRad (Backend Developer)',
    'Ambuj Chawla (Hacker)',
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTeamMemberItem(String name) {
    final match = RegExp(r'(.*)\s(\(.*\))').firstMatch(name);

    final String personName = match?.group(1) ?? name;

    final String personRole = match?.group(2) ?? '';

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "• " + personName,
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " " + personRole,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic, // Apply italics here
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color to match the home screen
      backgroundColor: const Color(0xFFf9fafc),

      appBar: const AppNavigationBar(showBackButton: false),

      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            // Padding from the screen edges
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                children: [
                  const Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172538),
                    ),
                    textAlign: TextAlign.left,
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFdddddd),
                    ),
                  ),

                  const Text(
                    "• For this year’s hackathon, I would like to develop a web app that is beneficial to the Tech Support team. \n• When assisting customers, the wire colors in their setup often do not match the colors shown in the wiring schematics provided in support articles. Some agents may manually edit wiring images by coloring over the wires before sending them to customers. While this helps improve clarity, the images often appear unprofessional. \n• This web app will allow agents to easily update and adjust wire colors within the schematics image, ensuring customers receive clear and polished visuals that improve their understanding of the installation process.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Development Team (Hack the Hive December 2025)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172538),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),

                  ...teamMembers.map(_buildTeamMemberItem).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
