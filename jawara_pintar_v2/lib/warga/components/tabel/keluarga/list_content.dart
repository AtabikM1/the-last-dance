import 'package:flutter/material.dart';
import '../../shared/status_chip.dart';
import '../../../../data/warga_data.dart';
import '../../detail/keluarga_detail_page.dart';

class ListContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final ScrollController scrollController;
  final int totalKeluarga;

  const ListContent({
    super.key,
    required this.filteredData,
    required this.scrollController,
    required this.totalKeluarga,
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
        final keluarga = filteredData[index];
        return _buildKeluargaCard(keluarga, context);
      },
    );
  }

  Widget _buildKeluargaCard(Map<String, dynamic> keluarga, BuildContext context) {
    final anggotaKeluarga = (keluarga['anggota'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDetail(keluarga, context),
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
                // Avatar/Icon keluarga
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.group_outlined,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Informasi keluarga
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama keluarga
                      Text(
                        keluarga['nama_keluarga'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      
                      // Kepala keluarga
                      Text(
                        "Kepala: ${keluarga['kepala_keluarga']}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      // Baris informasi pertama
                      Row(
                        children: [
                          // Alamat
                          Expanded(
                            child: _buildInfoChip(
                              keluarga['alamat'],
                              Icons.home_outlined,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          
                          // Jumlah anggota
                          _buildInfoChip(
                            '${anggotaKeluarga.length} Anggota',
                            Icons.people_outline,
                            Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      // Baris status
                      Row(
                        children: [
                          StatusChip(status: keluarga['status'], compact: true),
                          const SizedBox(width: 6),
                          _buildInfoChip(
                            keluarga['status_kepemilikan'],
                            Icons.house_siding_outlined,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Chevron indicator
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

  void _showDetail(Map<String, dynamic> keluarga, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KeluargaDetailPage(keluarga: keluarga),
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
            Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Tidak ada data keluarga ditemukan",
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