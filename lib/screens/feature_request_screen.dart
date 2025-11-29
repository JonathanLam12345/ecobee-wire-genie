import 'package:flutter/material.dart';

import '../app_bar/app_navigation_bar.dart';

class FeatureRequestScreen extends StatelessWidget {
  const FeatureRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),

      appBar: const AppNavigationBar(showBackButton: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Feature Requests',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172538),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Let us know what you would like to add to this web app. This could be a new wiring diagram, an additional tool, or an improvement to existing functionality.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(

                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: (1) SHOEIB'S Implement Firebase POST logic here
                    // TODO: (2) If user enters "ADMIN" here, the list of all submitted feature requests will show up below the text form. (Easter Egg Feature)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request submitted! (Functionality TO-DO by Shoeib)'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Request'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
