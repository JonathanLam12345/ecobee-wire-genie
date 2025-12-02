import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';

// 1. Create a simple model for a team member
class TeamMember {
  final String name;
  final String role;
  final String imagePath; // Path to the image asset

  const TeamMember({
    required this.name,
    required this.role,
    required this.imagePath,
  });
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
 final List<TeamMember> teamMembers = const [
    TeamMember(
      name: 'Jonathan Lam',
      role: 'Main Lead Developer',
      imagePath: 'assets/jonathan.png', // Replace with your actual path
    ),
    TeamMember(
      name: 'Shoeib MohamadiRad',
      role: 'Backend Developer',
      imagePath: 'assets/shoeib.png', // Replace with your actual path
    ),
    TeamMember(
      name: 'Ambuj Chawla',
      role: 'Hacker',
      imagePath: 'assets/ambuj.png', // Replace with your actual path
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTeamMemberItem(TeamMember member) {
    // Define the size for the image and circular clip
    const double imageSize = 100.0;

    return Padding(
      // Add horizontal padding to separate members
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Section
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: ClipOval(
              child: Image.asset(
                member.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback widget if the image fails to load
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: imageSize * 0.6, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Name Section (Bold)
          SelectableText(
            member.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172538),
            ),
          ),

          // Role Section (Italics)
          SelectableText(
            member.role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Color(0xFF172538),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),
      appBar: const AppNavigationBar(showBackButton: false),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    "• For this year’s hackathon, our team would like to develop a web app that is beneficial to the Tech Support team. \n• When assisting customers, the wire colors in their setup often do not match the colors shown in the wiring schematics provided in support articles. Some agents may manually edit wiring images by coloring over the wires before sending them to customers. While this helps improve clarity, the images often appear unprofessional. \n• This web app will allow agents to easily update and adjust wire colors within the schematics image, ensuring customers receive clear and polished visuals that improve their understanding of the installation process.",
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

                  // Use a Wrap or Row for displaying members
                  // Wrap is better for web to handle different screen widths
                  Wrap(
                    spacing: 24.0, // horizontal space between items
                    runSpacing: 16.0, // vertical space between lines of items
                    children: teamMembers.map(_buildTeamMemberItem).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}