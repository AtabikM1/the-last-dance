import 'package:flutter/material.dart';
import '../shared/status_chip_penerimaan.dart';
import '../../../../data/penerimaan_warga_data.dart';
import '../detail/detail_penerimaan_page.dart';
import '../shared/dialog_service.dart';
import '../../../services/toast_service.dart';

class ListContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final ScrollController scrollController;
  final int totalPendaftaran;

  const ListContent({
    super.key,
    required this.filteredData,
    required this.scrollController,
    required this.totalPendaftaran,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filteredData.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final pendaftaran = filteredData[index];
        return _buildSwipeablePendaftaranCard(pendaftaran, index + 1, context);
      },
    );
  }

  Widget _buildSwipeablePendaftaranCard(Map<String, dynamic> pendaftaran, int nomorUrut, BuildContext context) {
    return Dismissible(
      key: Key(pendaftaran['nik']?.toString() ?? UniqueKey().toString()),
      direction: DismissDirection.horizontal,
      background: _buildSwipeLeftBackground(pendaftaran),
      secondaryBackground: _buildSwipeRightBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await _showActivationConfirmation(pendaftaran, context);
        } else {
          return await _showDeleteConfirmation(pendaftaran, context);
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _deleteData(pendaftaran, context);
        }
      },
      child: _buildPendaftaranCard(pendaftaran, nomorUrut, context),
    );
  }

  Widget _buildSwipeLeftBackground(Map<String, dynamic> pendaftaran) {
    final status = pendaftaran['status_registrasi'];
    final isDiterima = status == 'Diterima';
    final isNonaktif = status == 'Nonaktif';
    final isPending = status == 'Pending';
    
    Color backgroundColor;
    IconData icon;
    String text;

    if (isPending) {
      backgroundColor = Colors.grey;
      icon = Icons.block;
      text = 'Tidak Tersedia';
    } else if (isDiterima) {
      backgroundColor = Colors.orange;
      icon = Icons.pause;
      text = 'Nonaktifkan';
    } else if (isNonaktif) {
      backgroundColor = Colors.green;
      icon = Icons.play_arrow;
      text = 'Aktifkan';
    } else {
      backgroundColor = Colors.grey;
      icon = Icons.block;
      text = 'Tidak Tersedia';
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeRightBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.delete, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendaftaranCard(Map<String, dynamic> pendaftaran, int nomorUrut, BuildContext context) {
    final jenisKelamin = pendaftaran['jenis_kelamin'] == 'L' ? 'Laki-laki' : 'Perempuan';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDetail(pendaftaran, context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.person_add_outlined,
                    color: Colors.purple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pendaftaran['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  pendaftaran['nik'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          StatusChipPenerimaan(status: pendaftaran['status_registrasi']),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoChip(
                              pendaftaran['email'],
                              Icons.email_outlined,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),

                          _buildInfoChip(
                            jenisKelamin,
                            Icons.person_outline,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
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

  Future<bool> _showDeleteConfirmation(Map<String, dynamic> pendaftaran, BuildContext context) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Pendaftaran'),
          ],
        ),
        content: Text('Apakah Anda yakin ingin menghapus pendaftaran "${pendaftaran['nama']}"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<bool> _showActivationConfirmation(Map<String, dynamic> pendaftaran, BuildContext context) async {
  final status = pendaftaran['status_registrasi'];
  final isDiterima = status == 'Diterima';
  final isNonaktif = status == 'Nonaktif';
  final isPending = status == 'Pending';
  
  if (isPending) {
    ToastService.showWarning(
      context,
      'Status Pending tidak bisa diaktifkan/nonaktifkan'
    );
    return false;
  }

  if (isDiterima) {
    PenerimaanWargaDialogService.showDeactivateDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        print('Menonaktifkan pendaftaran: ${pendaftaran['nama']}');
      },
    );
  } else if (isNonaktif) {
    PenerimaanWargaDialogService.showActivateDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        print('Mengaktifkan pendaftaran: ${pendaftaran['nama']}');
      },
    );
  }

  return false;
}

  void _showDetail(Map<String, dynamic> pendaftaran, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPenerimaanPage(pendaftaran: pendaftaran),
      ),
    );
  }

  void _deleteData(Map<String, dynamic> pendaftaran, BuildContext context) {
    print('Menghapus pendaftaran: ${pendaftaran['nama']}');
    
    PenerimaanWargaDialogService.showDeleteDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        print('Data ${pendaftaran['nama']} dihapus dari database');
      },
    );
  }

  void _toggleActivation(Map<String, dynamic> pendaftaran, BuildContext context) {

  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_disabled, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Tidak ada data pendaftaran ditemukan",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Coba ubah filter pencarian Anda",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}