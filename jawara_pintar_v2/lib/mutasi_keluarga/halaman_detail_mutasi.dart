import 'package:flutter/material.dart';
import '../../model/mutasi.dart';
import '../../sidebar/sidebar.dart'; // Sesuaikan dengan path sidebar Anda
import 'komponen/detail_mutasi_card.dart';

class MutasiDetailScreen extends StatelessWidget {
  final Mutasi mutasi;

  const MutasiDetailScreen({super.key, required this.mutasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jawara Pintar.'),
      ),
      drawer: const Sidebar(userEmail: "admin@jawara.com"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              label: const Text('Kembali'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Detail Mutasi Warga',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: DetailMutasiCard(mutasi: mutasi),
            ),
          ],
        ),
      ),
    );
  }
}