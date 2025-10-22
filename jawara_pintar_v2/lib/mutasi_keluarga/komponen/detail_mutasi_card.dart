import 'package:flutter/material.dart';
import '../../../model/mutasi.dart';

class DetailMutasiCard extends StatelessWidget {
  final Mutasi mutasi;

  const DetailMutasiCard({super.key, required this.mutasi});

  // Helper untuk membuat baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Keluarga:', mutasi.namaKeluarga),
            _buildDetailRow('Alamat Lama:', mutasi.alamatLama),
            _buildDetailRow('Alamat Baru:', mutasi.alamatBaru),
            _buildDetailRow('Tanggal Mutasi:', mutasi.tanggal),
            _buildDetailRow('Jenis Mutasi:', mutasi.jenisMutasi),
            _buildDetailRow('Alasan:', mutasi.alasan),
          ],
        ),
      ),
    );
  }
}