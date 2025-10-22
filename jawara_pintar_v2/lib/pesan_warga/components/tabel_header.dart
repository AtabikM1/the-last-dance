import 'package:flutter/material.dart';

class TabelHeaderAspirasi extends StatelessWidget {
  final int totalAspirasi;

  const TabelHeaderAspirasi({super.key, required this.totalAspirasi});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.announcement, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        const Text(
          "Daftar Aspirasi",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          "Total: $totalAspirasi aspirasi",
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
