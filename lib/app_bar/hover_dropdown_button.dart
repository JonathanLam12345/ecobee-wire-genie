import 'package:flutter/material.dart';

class HoverDropdownButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<String> menuItems;

  const HoverDropdownButton({
    super.key,
    required this.label,
    required this.icon,
    required this.menuItems,
  });

  @override
  State<HoverDropdownButton> createState() => _HoverDropdownButtonState();
}

class _HoverDropdownButtonState extends State<HoverDropdownButton> {
  final GlobalKey _buttonKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final RenderBox renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),

            Positioned(
              left: position.dx,
              top: position.dy + renderBox.size.height + 4.0,
              child: MouseRegion(
                onExit: (_) => _removeOverlay(),
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.menuItems.map((item) {
                      return InkWell(
                        onTap: () {
                          _handleMenuItemTap(context, item);
                          _removeOverlay(); // Dismiss after selection
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          width: renderBox.size.width,
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    // Insert the menu into the overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleMenuItemTap(BuildContext context, String item) {
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text('Selected Thermostat Model: $item')));

    if (item == 'Premium') {
      Navigator.pushNamed(context, '/premium');
    } else if (item == 'Enhanced') {
      Navigator.pushNamed(context, '/enhanced');
    } else if (item == 'Essential') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Essential - Coming Soon!!!'),
        ),
      );
    } else if (item == 'ecobee4/5') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text('ecobee4/5 - Coming Soon!!!'),
        ),
      );
    } else if (item == 'ecobee3 lite') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text('ecobee3 lite - Coming Soon!!!'),
        ),
      );
    } else if (item == 'ecobee3') {
      Navigator.pushNamed(context, '/ecobee3');
    } else {
      //Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showOverlay(), // Show menu on hover enter
      onExit: (_) {
        // This remains empty, allowing the cursor to move from the button
        // to the dropdown content without dismissing the menu prematurely.
      },
      child: TextButton.icon(
        key: _buttonKey,
        // Attach key for positioning
        icon: Icon(widget.icon, color: Colors.white),
        label: Text(widget.label, style: const TextStyle(color: Colors.white)),
        onPressed: () {
          // Default action on click (e.g., navigate to the home page, usually for the main category)
          _handleMenuItemTap(context, widget.menuItems.first);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
