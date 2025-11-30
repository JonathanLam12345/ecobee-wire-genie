import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final List<String> teamMembers = const [

  ];

  @override
  void initState() {
    super.initState();
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


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
