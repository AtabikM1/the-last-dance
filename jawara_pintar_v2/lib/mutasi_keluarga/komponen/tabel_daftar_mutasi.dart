import 'package:flutter/material.dart';
import '../../../model/mutasi.dart';

class MutasiListTable extends StatelessWidget {
  final List<Mutasi> mutasiList;
  final Function(Mutasi) onDetailTap;

  const MutasiListTable({
    super.key,
    required this.mutasiList,
    required this.onDetailTap,
  });

  // Helper untuk membuat status chip
  Widget _buildStatusChip(String jenisMutasi) {
    Color chipColor;
    Color textColor;

    if (jenisMutasi == 'Keluar Wilayah') {
      chipColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
    } else {
      chipColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    }

    return Chip(
      label: Text(
        jenisMutasi,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            // Tombol Filter
            ElevatedButton.icon(
              onPressed: () {
                // Logika filter
              },
              icon: const Icon(Icons.filter_list_alt, size: 18),
              label: const Text("Filter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tabel Data
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      MaterialStateProperty.all(Colors.grey[50]),
                  columns: const [
                    DataColumn(label: Text('NO')),
                    DataColumn(label: Text('TANGGAL')),
                    DataColumn(label: Text('KELUARGA')),
                    DataColumn(label: Text('JENIS MUTASI')),
                    DataColumn(label: Text('AKSI')),
                  ],
                  rows: mutasiList.asMap().entries.map((entry) {
                    int index = entry.key;
                    Mutasi mutasi = entry.value;
                    return DataRow(cells: [
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(mutasi.tanggal)),
                      DataCell(Text(mutasi.namaKeluarga)),
                      DataCell(_buildStatusChip(mutasi.jenisMutasi)),
                      DataCell(
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'detail') {
                              onDetailTap(mutasi);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'detail',
                              child: Text('Detail'),
                            ),
                          ],
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kontrol Paginasi (Mockup)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}