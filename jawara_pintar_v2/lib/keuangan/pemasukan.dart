import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml untuk format tanggal & mata uang
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path ini

// Model data untuk setiap baris pemasukan
class PemasukanData {
  final int no;
  final String nama;
  final String jenisPemasukan;
  final DateTime tanggal;
  final double nominal;

  PemasukanData({
    required this.no,
    required this.nama,
    required this.jenisPemasukan,
    required this.tanggal,
    required this.nominal,
  });
}

// --- Halaman Utama Laporan Pemasukan ---
class Pemasukan extends StatefulWidget {
  const Pemasukan({super.key});

  @override
  State<Pemasukan> createState() => _PemasukanState();
}
// (Pastikan semua import di atas file ini sudah benar)
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
// ... (Model PemasukanData) ...
// ... (Class Pemasukan) ...

class _PemasukanState extends State<Pemasukan> {
  // Data statis sebagai contoh
  final List<PemasukanData> _pemasukanList = [
    PemasukanData(
      no: 1,
      nama: 'Atabik',
      jenisPemasukan: 'Dana Bantuan Pemerintah',
      tanggal: DateTime(2025, 10, 15, 14, 23),
      nominal: 11000000,
    ),
    PemasukanData(
      no: 2,
      nama: 'Mutawakil',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 10, 13, 0, 55),
      nominal: 49999997,
    ),
    PemasukanData(
      no: 3,
      nama: 'Handoko',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 8, 12, 13, 26),
      nominal: 10000000,
    ),
  ];

  // --- State untuk UI ---
  int _currentPage = 1;
  List<PemasukanData> _filteredList =
      []; // List untuk menampung data hasil filter

  // --- State untuk filter ---
  final TextEditingController _namaFilterController = TextEditingController();
  String? _selectedKategori;
  DateTime? _selectedDariTanggal;
  DateTime? _selectedSampaiTanggal;
  final TextEditingController _dariTanggalController = TextEditingController();
  final TextEditingController _sampaiTanggalController =
      TextEditingController();

  // Opsi untuk dropdown kategori
  final List<String> _kategoriOptions = [
    'Dana Bantuan Pemerintah',
    'Pendapatan Lainnya',
  ];

  // --- Formatters (didefinisikan di sini agar efisien) ---
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ', // Tambah spasi agar rapi
    decimalDigits: 0, // Sesuai contoh UI, tidak pakai desimal
  );
  final dateFormatter = DateFormat('dd/MM/yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    // Saat pertama kali load, isi _filteredList dengan semua data
    _applyFilters();
  }

  @override
  void dispose() {
    _namaFilterController.dispose();
    _dariTanggalController.dispose();
    _sampaiTanggalController.dispose();
    super.dispose();
  }

  // --- FUNGSI BARU: Logika untuk memfilter data ---
  void _applyFilters() {
    setState(() {
      _filteredList = _pemasukanList.where((pemasukan) {
        // Filter Nama
        if (_namaFilterController.text.isNotEmpty &&
            !pemasukan.nama.toLowerCase().contains(
              _namaFilterController.text.toLowerCase(),
            )) {
          return false; // Sembunyikan jika tidak cocok
        }
        // Filter Kategori
        if (_selectedKategori != null &&
            pemasukan.jenisPemasukan != _selectedKategori) {
          return false; // Sembunyikan jika tidak cocok
        }
        // Filter Dari Tanggal
        if (_selectedDariTanggal != null &&
            pemasukan.tanggal.isBefore(_selectedDariTanggal!)) {
          return false;
        }
        // Filter Sampai Tanggal
        if (_selectedSampaiTanggal != null) {
          // Tambah 1 hari agar tanggal "sampai" menjadi inklusif
          final inclusiveSampaiTanggal = _selectedSampaiTanggal!.add(
            const Duration(days: 1),
          );
          if (pemasukan.tanggal.isAfter(inclusiveSampaiTanggal)) {
            return false;
          }
        }
        return true; // Tampilkan jika lolos semua filter
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com"; // Placeholder email

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Laporan Pemasukan"),
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
              // Ganti LayoutBuilder dan DataTable dengan Column dari list card
              _filteredList.isEmpty
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
                      children: _filteredList
                          .map((pemasukan) => _buildPemasukanCard(pemasukan))
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

  // --- WIDGET BARU: Untuk membangun Card Pemasukan (gaya dari gambar) ---
  Widget _buildPemasukanCard(PemasukanData pemasukan) {
    // --- Logika Kondisional untuk UI (sesuai gambar) ---
    // Kita samakan 'Dana Bantuan' dengan 'Synced' (biru/hijau)
    // dan 'Pendapatan Lainnya' dengan 'Not Synced' (merah)
    bool isBantuan = pemasukan.jenisPemasukan == 'Dana Bantuan Pemerintah';
    Color borderColor = isBantuan
        ? const Color(0xFF63C2DE)
        : const Color(0xFFF76C6C);
    Color statusColor = isBantuan
        ? const Color(0xFF28A745)
        : const Color(0xFFF76C6C);
    String statusText = isBantuan ? 'Bantuan' : 'Lainnya';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang card
        borderRadius: BorderRadius.circular(8),
        // Border kiri berwarna sesuai kondisi
        border: Border(left: BorderSide(color: borderColor, width: 5)),
        // Shadow tipis
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
                // Kiri: Jenis Pemasukan & Nama
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Ini seperti "Smartphone" di gambar
                        pemasukan.jenisPemasukan.toUpperCase(),
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
                        // Ini seperti "iPhone XR" di gambar
                        pemasukan.nama,
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
                // Kiri: TangGAL (seperti "Sync Date")
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
                        dateFormatter.format(pemasukan.tanggal),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Kanan: NOMINAL (seperti "Device OS")
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
                        currencyFormatter.format(pemasukan.nominal),
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
    // ... (Tidak ada perubahan, biarkan apa adanya)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
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
          onPressed: () {
            // Logika untuk halaman selanjutnya, sesuaikan jika data dinamis
            // setState(() => _currentPage++);
          },
        ),
      ],
    );
  }

  // Method untuk menampilkan dialog filter
  void _showFilterDialog(BuildContext context) {
    // ... (Tidak ada perubahan, biarkan apa adanya)
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
    // --- MODIFIKASI: Tombol "Terapkan" dan "Reset" ---
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
                "Filter Pemasukan",
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

          // --- Form Fields (Tidak ada perubahan) ---
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
          const Text("Kategori", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text("-- Pilih Kategori --"),
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
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setDialogState(() {
                _selectedKategori = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
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

          // --- Tombol Aksi Dialog (MODIFIKASI DI onPressed) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Reset semua filter
                  setDialogState(() {
                    _namaFilterController.clear();
                    _selectedKategori = null;
                    _selectedDariTanggal = null;
                    _selectedSampaiTanggal = null;
                    _dariTanggalController.clear();
                    _sampaiTanggalController.clear();
                  });
                  // Langsung terapkan filter (yang kosong)
                  _applyFilters();
                },
                child: const Text("Reset Filter"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Terapkan filter dan tutup dialog
                  _applyFilters(); // Panggil fungsi filter utama
                  Navigator.of(context).pop();
                },
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
    // ... (Tidak ada perubahan, biarkan apa adanya)
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
    // ... (Tidak ada perubahan, biarkan apa adanya)
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
