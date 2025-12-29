import 'package:flutter/material.dart';

class HoverDropdownButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<String> menuItems;
  final bool isActive; // New property to track if a sub-item is active

  const HoverDropdownButton({
    super.key,
    required this.label,
    required this.icon,
    required this.menuItems,
    this.isActive = false, // Defaults to false
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
            // Detect clicks outside to close
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
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.menuItems.map((item) {
                      return InkWell(
                        onTap: () {
                          _handleMenuItemTap(context, item);
                          _removeOverlay();
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
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleMenuItemTap(BuildContext context, String item) {
    if (item == 'Premium') {
      Navigator.pushNamed(context, '/premium');
    } else if (item == 'Enhanced') {
      Navigator.pushNamed(context, '/enhanced');
    } else if (item == 'Essential') {
      Navigator.pushNamed(context, '/essential');
    } else if (item == 'Heat-Only') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(duration: Duration(seconds: 3), content: Text('Heat-Only - Coming Soon!!!')),
      );
    } else if (item == 'ecobee4/5') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(duration: Duration(seconds: 3), content: Text('ecobee4/5 - Coming Soon!!!')),
      );
    } else if (item == 'ecobee3 lite') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(duration: Duration(seconds: 3), content: Text('ecobee3 lite - Coming Soon!!!')),
      );
    } else if (item == 'ecobee3') {
      Navigator.pushNamed(context, '/ecobee3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showOverlay(),
      child: Container(
        // The decoration provides the visual "Active" indicator
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          // Subtle highlight background
          color: widget.isActive ? Colors.white.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          // Bottom underline to show active status

        ),
        child: TextButton.icon(
          key: _buttonKey,
          icon: Icon(widget.icon, color: Colors.white),
          label: Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              // Make text bold if active
              fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onPressed: () {
            _handleMenuItemTap(context, widget.menuItems.first);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
    );
  }
}