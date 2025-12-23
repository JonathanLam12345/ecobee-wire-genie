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
      role: 'Lead Developer',
      imagePath: 'assets/jonathan.jpg',
    ),
    TeamMember(
      name: 'Shoeib MohamadiRad',
      role: 'Backend Developer',
      imagePath: 'assets/shoeib.jpeg',
    ),
    TeamMember(
      name: 'Ambuj Chawla',
      role: 'Graphics Designer',
      imagePath: 'assets/ambuj.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTeamMemberItem(TeamMember member) {
    const double imageSize = 100.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: ClipOval(
              child: Image.asset(
                member.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      size: imageSize * 0.6,
                      color: Colors.grey,
                    ),
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
        // Center the content on the screen
        child: Center(
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
                    "• For Hack the Hive Season 14, our team developed a web application that is beneficial to the Tech Support team. \n• When assisting customers, the wire colors in their setup often do not match the colors shown in the wiring schematics provided in support articles. Some agents may manually edit wiring images by coloring over the wires before sending them to customers. While this helps improve clarity, the images often appear unprofessional. \n• This web app will allow agents to easily update and adjust wire colors within the schematics image, ensuring customers receive clear and polished visuals that improve their understanding of the installation process.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Development Team',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 24.0,
                    runSpacing: 16.0,
                    children: teamMembers.map(_buildTeamMemberItem).toList(),
                  ),

                  SizedBox(height: 200),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "I dedicate this project to my grandma, who passed away during this hackathon.\n"
                        "Even though I hadn’t seen her as much recently, she always knew that my goal in life was to develop a project or invent something meaningful for others to use.\n\n"
                        "I had been planning this idea for a few months and was ready to execute it. I assigned tasks to my two team members. One worked on the presentation to communicate our idea to the audience and created some graphic logos.\n"
                        "For the other member, I assigned him to work on the backend and analytics. Although he was hesitant at first and preferred a simple “email us” feature request screen, he eventually built the backend and accomplished something he was also proud of.\n"
                        "Since I already understood the backend process, I was able to guide him through it.\n\n"
                        "After the presentation, a couple of agents were already making use of the web app, which made me proud.\n\n"
                        "In the end, our team won the People’s Choice Award and the Best Impact Award.\n"
                        "When I attended my grandma’s funeral, I placed the award with her as a meaningful gift—something to show her what I have achieved, and a promise that I will continue to achieve.\n",
                        style: TextStyle(fontSize: 11, height: 1.4),
                        textAlign: TextAlign.left,
                      ),
                    ),
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

/*


I dedicate this project to my grandma, who passed away during this hackathon.
Even though I hadn’t seen her as much recently, she always knew that my goal in life was to develop a project or invent something meaningful for others to use.

I had been planning this idea for a few months and was ready to execute it. I assigned tasks to my two team members. One worked on the presentation to communicate our idea to the audience and created some graphic logos.
For the other member, I assigned him to work on the backend. Although he was hesitant at first and preferred a simple “email us” feature request screen, he eventually built the backend and accomplished something he was also proud of.
Since I already understood the backend process, I was able to guide him through it.

After the presentation, a couple of agents were already making use of the web app so that made me proud.

In the end, our team won the People’s Choice Award and the Best Impact Award.
When I attended my grandma’s funeral, I placed the award with her as a meaningful gift—something to show her what I have achieved, and a promise that I will continue to achieve.

 grant my wish, wiregenie
 */
