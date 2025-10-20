import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan package 'intl' sudah ada di pubspec.yaml
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path ini

// Model data untuk setiap baris pengeluaran
class PengeluaranData {
  final int no;
  final String nama;
  final String jenisPengeluaran;
  final DateTime tanggal;
  final double nominal;

  PengeluaranData({
    required this.no,
    required this.nama,
    required this.jenisPengeluaran,
    required this.tanggal,
    required this.nominal,
  });
}

// --- Halaman Utama Laporan Pengeluaran ---
class Pengeluaran extends StatefulWidget {
  const Pengeluaran({super.key});

  @override
  State<Pengeluaran> createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  // Data statis sebagai contoh, sesuai gambar
  final List<PengeluaranData> _pengeluaranList = [
    PengeluaranData(
      no: 1,
      nama: 'Kerja Bakti',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 10, 19, 20, 26),
      nominal: 5000000,
    ),
    PengeluaranData(
      no: 2,
      nama: 'Kerja Bakti',
      jenisPengeluaran: 'Kegiatan Warga',
      tanggal: DateTime(2025, 10, 19, 20, 26),
      nominal: 10000000,
    ),
    PengeluaranData(
      no: 3,
      nama: 'Arka',
      jenisPengeluaran: 'Operasional RT/RW',
      tanggal: DateTime(2025, 10, 17, 2, 31),
      nominal: 6000000,
    ),
    PengeluaranData(
      no: 4,
      nama: 'adsad',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 10, 10, 1, 8),
      nominal: 2112000,
    ),
  ];

  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com"; // Placeholder email

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Laporan Pengeluaran"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tombol Filter
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logika untuk filter
                  },
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text(""), // Label dikosongkan
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tabel Data
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: 20,
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade100,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'NO',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NAMA',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'JENIS PENGELUARAN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TANGGAL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NOMINAL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'AKSI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: _pengeluaranList.map((pengeluaran) {
                          final currencyFormatter = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 2,
                          );
                          final dateFormatter = DateFormat(
                            'd MMM yyyy HH:mm',
                            'id_ID',
                          );

                          return DataRow(
                            cells: [
                              DataCell(Text(pengeluaran.no.toString())),
                              DataCell(Text(pengeluaran.nama)),
                              DataCell(Text(pengeluaran.jenisPengeluaran)),
                              DataCell(
                                Text(dateFormatter.format(pengeluaran.tanggal)),
                              ),
                              DataCell(
                                Text(
                                  currencyFormatter.format(pengeluaran.nominal),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () {
                                    // Logika untuk aksi
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Paginasi
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk kontrol paginasi
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
          color: Colors.grey,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF6A5AE0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _currentPage.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: null, // Dinonaktifkan untuk contoh ini
          color: Colors.grey,
        ),
      ],
    );
  }
}
