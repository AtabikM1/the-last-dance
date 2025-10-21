import 'package:flutter/material.dart';

class KegiatanDetailPage extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  const KegiatanDetailPage({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Kegiatan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan ikon dan judul
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.event,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Detail Kegiatan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 24),

                // Informasi kegiatan
                _buildDetailItem('Nama Kegiatan:', kegiatan['nama'] ?? '-'),
                _buildDetailItem('Kategori:', kegiatan['kategori'] ?? '-'),
                _buildDetailItem('Tanggal:', kegiatan['tanggal'] ?? '-'),
                _buildDetailItem('Lokasi:', kegiatan['lokasi'] ?? '-'),
                _buildDetailItem(
                  'Penanggung Jawab:',
                  kegiatan['penanggungJawab'] ?? '-',
                ),
                _buildDetailItem('Deskripsi:', kegiatan['deskripsi'] ?? '-'),
                _buildDetailItem('Dibuat Oleh:', kegiatan['dibuatOleh'] ?? '-'),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget helper untuk membangun baris detail
  Widget _buildDetailItem(String label, String value) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '-',
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
