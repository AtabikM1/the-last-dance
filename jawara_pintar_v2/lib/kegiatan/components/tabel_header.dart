import 'package:flutter/material.dart';

class TabelHeaderKegiatan extends StatelessWidget {
  final int totalKegiatan;

  const TabelHeaderKegiatan({super.key, required this.totalKegiatan});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.emoji_people_sharp, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        const Text(
          "Daftar Kegiatan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          "Total: $totalKegiatan kegiatan",
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
