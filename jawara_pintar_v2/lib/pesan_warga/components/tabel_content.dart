import 'package:flutter/material.dart';
import '../../warga/components/shared/action_buttons_warga.dart';
import '../../data/data_aspirasi.dart';
import 'action_buttons.dart' as btn;
import 'edit/edit_aspirasi_page.dart';
import 'detail/detail_aspirasi_page.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) => Colors.blueGrey[50],
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 15,
                ),
                dataTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                columnSpacing: 30,
                horizontalMargin: 20,
                headingRowHeight: 55,
                dataRowHeight: 65,
                columns: const [
                  DataColumn(label: Text('NO')),
                  DataColumn(label: Text('PENGIRIM')),
                  DataColumn(label: Text('JUDUL')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('TANGGAL')),
                  DataColumn(label: Center(child: Text('AKSI'))),
                ],
                rows: filteredData
                    .asMap()
                    .entries
                    .map(
                      (entry) => _buildDataRow(entry.key, entry.value, context),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  DataRow _buildDataRow(
    int index,
    Map<String, dynamic> aspirasi,
    BuildContext context,
  ) {
    int nomorUrut = ((currentPage - 1) * itemsPerPage) + index + 1;

    return DataRow(
      cells: [
        DataCell(Center(child: Text(nomorUrut.toString()))),
        DataCell(Text(aspirasi['dibuat_oleh'] ?? '-')),
        DataCell(Text(aspirasi['judul'] ?? '-')),
        DataCell(Text(aspirasi['status'] ?? '-')),
        DataCell(Text(aspirasi['tanggal_dibuat'] ?? '-')),
        DataCell(
          Center(
            child: btn.ActionPopupMenu(
              onDetail: () => _showDetail(aspirasi, context),
              onEdit: () => _editData(aspirasi, context),
              onDelete: () {},
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(Map<String, dynamic> aspirasi, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AspirasiDetailPage(aspirasi: aspirasi),
      ),
    );
  }

  void _editData(Map<String, dynamic> aspirasi, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AspirasiEditPage(aspirasi: aspirasi),
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
