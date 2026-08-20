import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  const ProfileData({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const Spacer(),
        Text(value),
      ],
    );
  }
}
