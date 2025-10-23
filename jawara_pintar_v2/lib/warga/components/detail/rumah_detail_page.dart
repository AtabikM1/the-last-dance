import 'package:flutter/material.dart';
import '../edit/rumah_edit_page.dart';

class RumahDetailPage extends StatelessWidget {
  final Map<String, dynamic> rumah;

  const RumahDetailPage({
    super.key,
    required this.rumah,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Rumah",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RumahEditPage(rumah: rumah)));
            },
            tooltip: 'Edit Data',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeaderSection(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildInfoSection(),
              _buildPenghuniSection(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9A3D), Color(0xFFFF6B6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.house_outlined, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rumah['alamat'] ?? '-',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  "Status: ${rumah['status'] ?? '-'}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusChip(
                      rumah['status'] ?? '-',
                      _getStatusColor(rumah['status'] ?? '-'),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(
                      rumah['status_kepemilikan'] ?? '-',
                      Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                "Informasi Rumah",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Alamat Lengkap', rumah['alamat'] ?? '-', Icons.home_outlined),
          _buildInfoItem('RT/RW', '${rumah['rt'] ?? '-'}/${rumah['rw'] ?? '-'}', Icons.location_on_outlined),
          _buildInfoItem('Status Rumah', rumah['status'] ?? '-', Icons.home_work_outlined),
          _buildInfoItem('Status Kepemilikan', rumah['status_kepemilikan'] ?? '-', Icons.house_siding_outlined),
          _buildInfoItem('Jumlah Penghuni', '${rumah['jumlah_penghuni'] ?? '0'} orang', Icons.people_outline),
          _buildInfoItem('Luas Bangunan', '${rumah['luas_bangunan'] ?? '-'} m²', Icons.square_foot_outlined),
          _buildInfoItem('Luas Tanah', '${rumah['luas_tanah'] ?? '-'} m²', Icons.landscape_outlined),
        ],
      ),
    );
  }

  Widget _buildPenghuniSection() {
    // Contoh data penghuni - sesuaikan dengan struktur data Anda
    final List<Map<String, dynamic>> penghuni = rumah['penghuni'] ?? [];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.people_alt_outlined, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                "Penghuni Rumah",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  penghuni.length.toString(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (penghuni.isEmpty)
            _buildEmptyState()
          else
            ...penghuni.asMap().entries.map((entry) {
              final index = entry.key;
              final penghuniData = entry.value;
              return _buildPenghuniCard(penghuniData, index + 1);
            }),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenghuniCard(Map<String, dynamic> penghuni, int nomorUrut) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                nomorUrut.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  penghuni['nama'] ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  penghuni['nik'] ?? '-',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildPenghuniInfoChip(
                        penghuni['peran'] ?? '-',
                        Icons.person_outline,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildPenghuniInfoChip(
                      penghuni['jenis_kelamin'] ?? '-',
                      Icons.transgender,
                      Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    _buildStatusChip(
                      penghuni['status'] ?? '-',
                      _getStatusColor(penghuni['status'] ?? '-'),
                    ),
                    const SizedBox(width: 6),
                    _buildPenghuniInfoChip(
                      penghuni['tanggal_mulai'] ?? '-',
                      Icons.calendar_today_outlined,
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenghuniInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Belum ada penghuni",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Data penghuni rumah belum tersedia",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ditempati':
      case 'aktif':
        return Colors.green;
      case 'tersedia':
        return Colors.blue;
      case 'dalam perbaikan':
        return Colors.orange;
      case 'tidak aktif':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}