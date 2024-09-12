import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final String title;
  final double? height;
  final VoidCallback onPressed;

  const BasicAppButton({
    super.key,
    this.height,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 80),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
