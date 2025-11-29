import 'package:flutter/material.dart';

import 'hover_dropdown_button.dart';

/// Reusable AppBar for consistent navigation across all screens.
class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  // A function to handle navigation specific to the current page.
  final bool showBackButton;
  final VoidCallback? onAboutTap;

  const AppNavigationBar({
    super.key,
    // By default, show back button if the screen is pushed on top of another.
    this.showBackButton = true,
    this.onAboutTap,
  });

  Widget _buildNavBarButton({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return TextButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  // Required by PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "",
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF172538),
      // Control back button display
      automaticallyImplyLeading: showBackButton,
      actions: [
        // *** START MODIFICATION: ADDED HOME BUTTON ***
        _buildNavBarButton(
          label: "Home Menu",
          icon: Icons.home,
          onTap: () {
            // Navigate back to the instructional home screen
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        // *** END MODIFICATION ***
        HoverDropdownButton(
          label: "Thermostat",
          icon: Icons.thermostat,
          menuItems: const [
            'Premium',
            'Enhanced',
            'Essential',
            'SmartThermostat with Voice Control',
            'ecobee3 lite',
            'ecobee4',
            'ecobee3'
          ],
        ),
        _buildNavBarButton(
          label: "Doorbell Camera",
          icon: Icons.doorbell,
          onTap: () {
            // Add navigation logic for Doorbell Camera here
          },
        ),
        _buildNavBarButton(
          label: "Switch+",
          icon: Icons.lightbulb,
          onTap: () {
            // Add navigation logic for Switch+ here
          },
        ),

        _buildNavBarButton(
          label: "About us",
          icon: Icons.info,
          onTap: onAboutTap ??
                  () {
                // Default: Navigate to the About screen
                Navigator.pushNamed(context, '/about');
              },
        ),
        _buildNavBarButton(
          label: "Feature Requests",
          icon: Icons.featured_play_list,
          onTap: onAboutTap ??
                  () {
                // *** MODIFICATION: Navigate to the new FeatureRequestScreen ***
                Navigator.pushNamed(context, '/feature_request');
              },
        ),
        const SizedBox(width: 80), // Add some spacing at the end
      ],
    );
  }
}
