import 'package:flutter/material.dart';

import 'hover_dropdown_button.dart';

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


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Get the current route name to prevent redundant navigation
    final currentRoute = ModalRoute.of(context)?.settings.name;

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
        // Home Menu
        _buildNavBarButton(
          label: "Home",
          icon: Icons.home,
          onTap: () {
            if (currentRoute != '/home') {
              // Navigate back to the instructional home screen and clear the stack
              // We use pushReplacementNamed here to ensure the navigation stack is shallow.
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
        HoverDropdownButton(
          label: "Thermostat",
          icon: Icons.thermostat,
          menuItems: const [
            'Premium',
            'Enhanced',
            'Essential',
            'ecobee4/5',
            'ecobee3 lite',
            'ecobee3'
          ],
        ),
        _buildNavBarButton(
          label: "Doorbell Camera",
          icon: Icons.doorbell,
          onTap: () {

            Navigator.pushNamed(context, '/doorbell');
          },
        ),
        // _buildNavBarButton(
        //   label: "AI",
        //   icon: Icons.psychology,
        //   onTap: () {
        //     // Add navigation logic for Switch+ here
        //   },
        // ),
        _buildNavBarButton(
          label: "About us",
          icon: Icons.info,
          onTap: onAboutTap ??
                  () {
                if (currentRoute != '/about') {
                  Navigator.pushNamed(context, '/about');
                }
              },
        ),
        _buildNavBarButton(
          label: "Feature Requests",
          icon: Icons.featured_play_list,
          onTap: () {
            if (currentRoute != '/feature_request') {

              Navigator.pushNamed(context, '/feature_request');
            }
          },
        ),
        const SizedBox(width: 80), // Add some spacing at the end
      ],
    );
  }
}