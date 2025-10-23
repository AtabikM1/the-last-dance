import 'package:flutter/material.dart';
import '../shared/status_chip_penerimaan.dart';
import '../shared/dialog_service.dart';

class DetailPenerimaanPage extends StatelessWidget {
  final Map<String, dynamic> pendaftaran;

  const DetailPenerimaanPage({
    super.key,
    required this.pendaftaran,
  });

  void _approveData(BuildContext context) {
    PenerimaanWargaDialogService.showApproveDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        // TODO: Implement approve logic
        Navigator.of(context).pop();
      },
    );
  }

  void _rejectData(BuildContext context) {
    PenerimaanWargaDialogService.showRejectDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        // TODO: Implement reject logic
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = pendaftaran['status_registrasi'];
    final isPending = status == 'Pending';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Pendaftaran",
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
          if (isPending) ...[
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _approveData(context),
              tooltip: 'Setujui',
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _rejectData(context),
              tooltip: 'Tolak',
            ),
          ],
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
              _buildFotoSection(),
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
          colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
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
            child: const Icon(Icons.person_add_outlined, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pendaftaran['nama'] ?? '-',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  pendaftaran['email'] ?? '-',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusChip(
                      pendaftaran['status_registrasi'] ?? '-',
                      _getStatusColor(pendaftaran['status_registrasi'] ?? '-'),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(
                      pendaftaran['jenis_kelamin'] == 'L' ? 'Laki-laki' : 'Perempuan',
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
                "Informasi Pendaftaran",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Nama Lengkap', pendaftaran['nama'] ?? '-', Icons.person_outline),
          _buildInfoItem('NIK', pendaftaran['nik'] ?? '-', Icons.badge_outlined),
          _buildInfoItem('Email', pendaftaran['email'] ?? '-', Icons.email_outlined),
          _buildInfoItem('Jenis Kelamin', 
            pendaftaran['jenis_kelamin'] == 'L' ? 'Laki-laki' : 'Perempuan', 
            Icons.transgender),
          _buildInfoItem('Status', '', 
            Icons.person_add_outlined,
            customWidget: StatusChipPenerimaan(status: pendaftaran['status_registrasi'] ?? '-')),
        ],
      ),
    );
  }

  Widget _buildFotoSection() {
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
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library_outlined, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                "Foto Identitas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) => _buildFotoContent(context),
          ),
        ],
      ),
    );
  }


  Widget _buildInfoItem(String label, String value, IconData icon, {Widget? customWidget}) {
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
                customWidget ?? Text(
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

  Widget _buildFotoContent(context) {
    return GestureDetector(
      onTap: () {
        PenerimaanWargaDialogService.showFotoIdentitasDialog(
          context: context,
          nama: pendaftaran['nama'],
          fotoIdentitas: pendaftaran['foto_identitas'],
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Foto KTP / Identitas',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pendaftaran['foto_identitas'] ?? 'foto_identitas.jpg',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tap untuk melihat',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.green;
      case 'Pending':
        return Colors.blue;
      case 'Nonaktif':
        return Colors.orange;
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}