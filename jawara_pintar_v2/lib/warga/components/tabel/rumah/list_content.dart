import 'package:flutter/material.dart';
import '../../shared/status_chip.dart';
import '../../../../data/rumah_data.dart';
import '../../detail/rumah_detail_page.dart';
import '../../delete/rumah_delete_page.dart';

class ListContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final ScrollController scrollController;
  final int totalRumah;

  const ListContent({
    super.key,
    required this.filteredData,
    required this.scrollController,
    required this.totalRumah,
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
        final rumah = filteredData[index];
        return _buildSwipeableRumahCard(rumah, index + 1, context);
      },
    );
  }

  Widget _buildSwipeableRumahCard(Map<String, dynamic> rumah, int nomorUrut, BuildContext context) {
    return Dismissible(
      key: Key(rumah['alamat']?.toString() ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(),
      secondaryBackground: _buildSwipeBackground(),
      confirmDismiss: (direction) async {
        return await RumahDelete.showDeleteConfirmationDialog(
          context: context,
          alamat: rumah['alamat']?.toString() ?? 'Rumah ini',
          onConfirmDelete: () {
          },
        );
      },
      onDismissed: (direction) {
        RumahDelete.deleteRumah(
          context: context,
          rumah: rumah,
          onSuccess: () {
          },
        );
      },
      child: _buildRumahCard(rumah, nomorUrut, context),
    );
  }

  Widget _buildSwipeBackground() {
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
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Hapus',
                style: TextStyle(
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

  Widget _buildRumahCard(Map<String, dynamic> rumah, int nomorUrut, BuildContext context) {
    final alamat = rumah['alamat']?.toString() ?? 'Alamat tidak tersedia';
    final rt = rumah['rt']?.toString() ?? '-';
    final rw = rumah['rw']?.toString() ?? '-';
    final status = rumah['status']?.toString() ?? '-';
    final statusKepemilikan = rumah['status_kepemilikan']?.toString() ?? '-';
    final jumlahPenghuni = rumah['jumlah_penghuni']?.toString() ?? '0';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDetail(rumah, context),
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.house_outlined,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alamat,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 6),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoChip(
                              'RT $rt/RW $rw',
                              Icons.location_on_outlined,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          
                          StatusChip(status: status, compact: true),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      Row(
                        children: [
                          _buildInfoChip(
                            '$jumlahPenghuni Penghuni',
                            Icons.people_outline,
                            Colors.green,
                          ),
                          const SizedBox(width: 8),

                          _buildInfoChip(
                            statusKepemilikan,
                            Icons.home_work_outlined,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
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

  void _showDetail(Map<String, dynamic> rumah, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RumahDetailPage(rumah: rumah),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.house_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Tidak ada data rumah ditemukan",
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