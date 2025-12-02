import 'package:flutter/material.dart';


class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;

  const ColorPickerDialog({super.key, required this.initialColor});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.black,
      Colors.grey,
      Colors.white
    ];

    return AlertDialog(
      title: const Text('Pick a wire color'),
      content: Wrap(
        spacing: 8,
        children: colors
            .map(
              (c) => GestureDetector(
            onTap: () => Navigator.pop(context, c),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: c == initialColor ? 3 : 1,
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}