import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final String text;
  final Color textColor;

  const OrDivider({
    super.key,
    this.thickness = 1.0,
    this.color = Colors.grey,
    this.text = 'OR',
    this.textColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: color, thickness: thickness),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text, style: TextStyle(color: textColor)),
        ),
        Expanded(
          child: Divider(color: color, thickness: thickness),
        ),
      ],
    );
  }
}
