import 'package:flutter/material.dart';

class HoverTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const HoverTextButton({super.key, required this.onPressed, required this.text});

  @override
  _HoverTextButtonState createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<HoverTextButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: isHovered ? Colors.blue : Colors.black,
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
