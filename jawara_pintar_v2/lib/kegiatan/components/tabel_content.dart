import 'package:flutter/material.dart';
import '../../warga/components/shared/action_buttons_warga.dart';
import '../../data/kegiatan_data.dart';
import '../components/edit/edit_kegiatan_page.dart';
import '../components/detail/detail_kegiatan_page.dart';

class TabelContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final int currentPage;
  final int itemsPerPage;

  const TabelContent({
    super.key,
    required this.filteredData,
    this.currentPage = 1,
    this.itemsPerPage = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      constraints: const BoxConstraints(
        // minHeight: 200,
        // maxHeight: 400,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => Colors.blueGrey[50],
          ),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          dataTextStyle: const TextStyle(color: Colors.black87),
          columnSpacing: 20,
          horizontalMargin: 20,
          headingRowHeight: 50,
          dataRowHeight: 60,
          columns: const [
            DataColumn(label: Text('NO'), numeric: true),
            DataColumn(label: Text('NAMA KEGIATAN')),
            DataColumn(label: Text('KATEGORI')),
            DataColumn(label: Text('PENANGGUNG JAWAB')),
            DataColumn(label: Text('TANGGAL PELAKSANAAN')),
            DataColumn(label: Center(child: Text('AKSI'))),
          ],
          rows: filteredData
              .asMap()
              .entries
              .map((entry) => _buildDataRow(entry.key, entry.value, context))
              .toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    int index,
    Map<String, dynamic> kegiatan,
    BuildContext context,
  ) {
    int nomorUrut = ((currentPage - 1) * itemsPerPage) + index + 1;

    return DataRow(
      cells: [
        DataCell(Center(child: Text(nomorUrut.toString()))),
        DataCell(Text(kegiatan['nama'])),
        DataCell(Text(kegiatan['kategori'])),
        DataCell(Text(kegiatan['penanggungJawab'])),
        DataCell(Text(kegiatan['tanggal'])),
        DataCell(
          Center(
            child: ActionButtons(
              onDetail: () => _showDetail(kegiatan, context),
              onEdit: () => _editData(kegiatan, context),
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(Map<String, dynamic> kegiatan, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KegiatanDetailPage(kegiatan: kegiatan),
      ),
    );
  }

  void _editData(Map<String, dynamic> kegiatan, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KegiatanEditPage(kegiatan: kegiatan),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Tidak ada data yang ditemukan",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
