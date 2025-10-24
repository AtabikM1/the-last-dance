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
  // Data statis sebagai contoh
  final List<PengeluaranData> _allPengeluaranList = [
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

  // List untuk data yang sudah difilter
  List<PengeluaranData> _filteredPengeluaranList = [];

  int _currentPage = 1;

  // State untuk menyimpan nilai filter
  final TextEditingController _namaFilterController = TextEditingController();
  String? _selectedKategori;
  DateTime? _selectedDariTanggal;
  DateTime? _selectedSampaiTanggal;
  final TextEditingController _dariTanggalController = TextEditingController();
  final TextEditingController _sampaiTanggalController =
      TextEditingController();

  // Opsi untuk dropdown
  List<String> _kategoriOptions = [];

  // --- BARU: Pindahkan Formatter ke level class agar efisien ---
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ', // Tambah spasi
    decimalDigits: 0, // Hilangkan desimal untuk UI card
  );
  final dateFormatter = DateFormat('dd/MM/yyyy', 'id_ID');
  // --- Akhir Bagian Baru ---

  @override
  void initState() {
    super.initState();
    // Ambil jenis unik dari data list
    final uniqueJenis = _allPengeluaranList
        .map((p) => p.jenisPengeluaran)
        .toSet();
    _kategoriOptions = uniqueJenis.toList();
    // Awalnya, tampilkan semua data
    _filteredPengeluaranList = List.from(_allPengeluaranList);
  }

  @override
  void dispose() {
    _namaFilterController.dispose();
    _dariTanggalController.dispose();
    _sampaiTanggalController.dispose();
    super.dispose();
  }

  // Logika untuk menerapkan filter
  void _applyFilter() {
    setState(() {
      _filteredPengeluaranList = _allPengeluaranList.where((pengeluaran) {
        final bool namaMatch =
            _namaFilterController.text.isEmpty ||
            pengeluaran.nama.toLowerCase().contains(
              _namaFilterController.text.toLowerCase(),
            );

        final bool kategoriMatch =
            _selectedKategori == null ||
            pengeluaran.jenisPengeluaran == _selectedKategori;

        final bool dariTanggalMatch =
            _selectedDariTanggal == null ||
            pengeluaran.tanggal.isAfter(
              _selectedDariTanggal!.subtract(const Duration(seconds: 1)),
            );

        final bool sampaiTanggalMatch =
            _selectedSampaiTanggal == null ||
            pengeluaran.tanggal.isBefore(
              _selectedSampaiTanggal!.add(const Duration(days: 1)),
            );

        return namaMatch &&
            kategoriMatch &&
            dariTanggalMatch &&
            sampaiTanggalMatch;
      }).toList();
    });
    Navigator.of(context).pop(); // Tutup dialog
  }

  // Logika untuk reset filter
  void _resetFilter(void Function(void Function()) setDialogState) {
    setDialogState(() {
      _namaFilterController.clear();
      _selectedKategori = null;
      _selectedDariTanggal = null;
      _selectedSampaiTanggal = null;
      _dariTanggalController.clear();
      _sampaiTanggalController.clear();
    });
    // Terapkan reset ke list utama
    setState(() {
      _filteredPengeluaranList = List.from(_allPengeluaranList);
    });
  }

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
                    _showFilterDialog(context);
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

              // --- PERUBAHAN UTAMA: GANTI DataTable MENJADI Column ---
              _filteredPengeluaranList.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "Data tidak ditemukan.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  : Column(
                      children: _filteredPengeluaranList
                          .map(
                            (pengeluaran) => _buildPengeluaranCard(pengeluaran),
                          )
                          .toList(),
                    ),

              // --- AKHIR PERUBAHAN ---
              const SizedBox(height: 24),
              // Paginasi
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BARU: Untuk membangun Card Pengeluaran (gaya dari gambar) ---
  Widget _buildPengeluaranCard(PengeluaranData pengeluaran) {
    // Logika kondisional UI (sesuai gambar)
    // Kita buat logika sederhana: 'Pemeliharaan Fasilitas' berwarna biru, sisanya merah
    bool isFasilitas = pengeluaran.jenisPengeluaran == 'Pemeliharaan Fasilitas';
    Color borderColor = isFasilitas
        ? const Color(0xFF63C2DE)
        : const Color(0xFFF76C6C);
    Color statusColor = isFasilitas
        ? const Color(0xFF28A745)
        : const Color(0xFFF76C6C);
    String statusText = isFasilitas
        ? 'Fasilitas'
        : 'Lainnya'; // Teks status sederhana

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: borderColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Baris Atas (Nama, Status, Aksi) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: Jenis Pengeluaran & Nama
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pengeluaran.jenisPengeluaran.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pengeluaran.nama,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Kanan: Status & Aksi
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Status (dot & text)
                    Icon(Icons.circle, color: statusColor, size: 10),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tombol Aksi (3 titik)
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        // Logika untuk aksi (edit, delete, dll)
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)), // Garis pemisah
            const SizedBox(height: 16),

            // --- Baris Bawah (Tanggal & Nominal) ---
            Row(
              children: [
                // Kiri: TANGGAL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TANGGAL",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormatter.format(pengeluaran.tanggal),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Kanan: NOMINAL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NOMINAL",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormatter.format(pengeluaran.nominal),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // --- AKHIR WIDGET BARU ---

  // Widget untuk kontrol paginasi
  Widget _buildPagination() {
    // ... (Tidak ada perubahan)
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

  // Method untuk menampilkan dialog filter
  void _showFilterDialog(BuildContext context) {
    // ... (Tidak ada perubahan)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: _buildFilterDialogContent(context, setDialogState),
            );
          },
        );
      },
    );
  }

  // Method untuk membangun konten dialog
  Widget _buildFilterDialogContent(
    BuildContext context,
    void Function(void Function()) setDialogState,
  ) {
    // ... (Tidak ada perubahan)
    return Container(
      padding: const EdgeInsets.all(24.0),
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Dialog ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Pengeluaran",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Form Fields ---
          // Nama
          const Text("Nama", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _namaFilterController,
            decoration: InputDecoration(
              hintText: "Cari nama...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Kategori (Jenis Pengeluaran)
          const Text(
            "Jenis Pengeluaran",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text("-- Pilih Jenis Pengeluaran --"),
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            items: _kategoriOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (newValue) {
              setDialogState(() {
                _selectedKategori = newValue;
              });
            },
          ),
          const SizedBox(height: 16),

          // Dari Tanggal
          const Text(
            "Dari Tanggal",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDatePickerField(
            context: context,
            controller: _dariTanggalController,
            onDateSelected: (date) {
              setDialogState(() {
                _selectedDariTanggal = date;
              });
            },
            onClear: () {
              setDialogState(() {
                _selectedDariTanggal = null;
                _dariTanggalController.clear();
              });
            },
          ),
          const SizedBox(height: 16),

          // Sampai Tanggal
          const Text(
            "Sampai Tanggal",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDatePickerField(
            context: context,
            controller: _sampaiTanggalController,
            onDateSelected: (date) {
              setDialogState(() {
                _selectedSampaiTanggal = date;
              });
            },
            onClear: () {
              setDialogState(() {
                _selectedSampaiTanggal = null;
                _sampaiTanggalController.clear();
              });
            },
          ),
          const SizedBox(height: 24),

          // --- Tombol Aksi Dialog ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _resetFilter(setDialogState);
                },
                child: const Text("Reset Filter"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A5AE0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: const Text("Terapkan"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget helper untuk field tanggal
  Widget _buildDatePickerField({
    // ... (Tidak ada perubahan)
    required BuildContext context,
    required TextEditingController controller,
    required Function(DateTime) onDateSelected,
    required VoidCallback onClear,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "-- / -- / ----",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: onClear,
              splashRadius: 20,
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, size: 20),
              onPressed: () => _pickDate(context, controller, onDateSelected),
              splashRadius: 20,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      onTap: () => _pickDate(context, controller, onDateSelected),
    );
  }

  // Logika untuk memunculkan date picker
  Future<void> _pickDate(
    // ... (Tidak ada perubahan)
    BuildContext context,
    TextEditingController controller,
    Function(DateTime) onDateSelected,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDariTanggal ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd / MM / yyyy').format(pickedDate);
      controller.text = formattedDate;
      onDateSelected(pickedDate);
    }
  }
}
