import 'package:flutter/material.dart';
import 'hover_dropdown_button.dart';

class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onAboutTap;

  const AppNavigationBar({
    super.key,
    this.showBackButton = true,
    this.onAboutTap,
  });



  // Updated helper to accept 'isActive' boolean
  Widget _buildNavBarButton({
    required String label,
    required IconData icon,
    required bool isActive, // New parameter
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        // Highlight the background if active
        color: isActive ? Colors.white.withOpacity(0.10) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        // Alternatively: Add a bottom border for a "tab" look

      ),
      child: TextButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Get the current route name
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Define all routes that should highlight the "Thermostat" button
    final thermostatRoutes =[
      '/premium',
      '/enhanced',
      '/essential',
      'Heat-Only',
      'ecobee4/5',
      'ecobee3 lite',
      '/ecobee3'
    ];
// Check if current route is in the list
    final isThermostatActive = thermostatRoutes.contains(currentRoute);

    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF172538),
      automaticallyImplyLeading: showBackButton,
      actions: [
        _buildNavBarButton(
          label: "Home",
          icon: Icons.home,
          isActive: currentRoute == '/home', // Logic check
          onTap: () {
            if (currentRoute != '/home') {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),


        HoverDropdownButton(
          label: "Thermostat",
          icon: Icons.thermostat,

          isActive: isThermostatActive,
          menuItems: const [
            'Premium',
            'Enhanced',
            'Essential',
            'Heat-Only',
            'ecobee4/5',
            'ecobee3 lite',
            'ecobee3'
          ],
        ),

        _buildNavBarButton(
          label: "Doorbell Camera",
          icon: Icons.doorbell,
          isActive: currentRoute == '/doorbell',
          onTap: () => Navigator.pushNamed(context, '/doorbell'),
        ),

        _buildNavBarButton(
          label: "About us",
          icon: Icons.info,
          isActive: currentRoute == '/about',
          onTap: onAboutTap ?? () {
            if (currentRoute != '/about') Navigator.pushNamed(context, '/about');
          },
        ),

        _buildNavBarButton(
          label: "Feature Requests",
          icon: Icons.featured_play_list,
          isActive: currentRoute == '/feature_request',
          onTap: () {
            if (currentRoute != '/feature_request') {
              Navigator.pushNamed(context, '/feature_request');
            }
          },
        ),
        const SizedBox(width: 80),
      ],
    );
  }
}