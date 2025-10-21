import 'package:flutter/material.dart';
import '../../../data/kegiatan_data.dart';

class FormKegiatan extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final GlobalKey<FormState> formKey;
  final Function(String) onNamaChanged;
  final Function(String) onKategoriChanged;
  final Function(String) onDeskripsiChanged;
  final Function(String) onTanggalChanged;
  final Function(String) onLokasiChanged;
  final Function(String) onPenanggungJawabChanged;
  final Function(String) onDibuatOlehChanged;

  const FormKegiatan({
    super.key,
    required this.initialData,
    required this.formKey,
    required this.onNamaChanged,
    required this.onKategoriChanged,
    required this.onDeskripsiChanged,
    required this.onTanggalChanged,
    required this.onLokasiChanged,
    required this.onPenanggungJawabChanged,
    required this.onDibuatOlehChanged,
  });

  @override
  State<FormKegiatan> createState() => _FormKegiatanState();
}

class _FormKegiatanState extends State<FormKegiatan> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _tanggalController;
  late TextEditingController _lokasiController;
  late TextEditingController _penanggungJawabController;
  late TextEditingController _dibuatOlehController;

  String? selectedKategori;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.initialData['nama'] ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.initialData['deskripsi'] ?? '',
    );
    _tanggalController = TextEditingController(
      text: widget.initialData['tanggal'] ?? '',
    );
    _lokasiController = TextEditingController(
      text: widget.initialData['lokasi'] ?? '',
    );
    _penanggungJawabController = TextEditingController(
      text: widget.initialData['penanggungJawab'] ?? '',
    );
    _dibuatOlehController = TextEditingController(
      text: widget.initialData['dibuatOleh'] ?? '',
    );
    selectedKategori = widget.initialData['kategori'] ?? null;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    _lokasiController.dispose();
    _penanggungJawabController.dispose();
    _dibuatOlehController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      final formattedDate =
          "${picked.day} ${_getNamaBulan(picked.month)} ${picked.year}";
      setState(() {
        _tanggalController.text = formattedDate;
      });
      widget.onTanggalChanged(formattedDate);
    }
  }

  String _getNamaBulan(int bulan) {
    const bulanList = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return bulanList[bulan - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Kegiatan
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(
              labelText: 'Nama Kegiatan',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onNamaChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          // Kategori
          DropdownButtonFormField<String>(
            value: selectedKategori,
            items: KegiatanData.kategoriKegiatan
                .map(
                  (kategori) =>
                      DropdownMenuItem(value: kategori, child: Text(kategori)),
                )
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Kategori',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => selectedKategori = value);
              if (value != null) widget.onKategoriChanged(value);
            },
          ),
          const SizedBox(height: 12),

          // Deskripsi
          TextFormField(
            controller: _deskripsiController,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onSaved: (value) => widget.onDeskripsiChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          // Tanggal Pelaksanaan
          TextFormField(
            controller: _tanggalController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Tanggal Pelaksanaan',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pilihTanggal(context),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Lokasi
          TextFormField(
            controller: _lokasiController,
            decoration: const InputDecoration(
              labelText: 'Lokasi',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onLokasiChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          // Penanggung Jawab
          TextFormField(
            controller: _penanggungJawabController,
            decoration: const InputDecoration(
              labelText: 'Penanggung Jawab',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onPenanggungJawabChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          // Dibuat Oleh
          TextFormField(
            controller: _dibuatOlehController,
            decoration: const InputDecoration(
              labelText: 'Dibuat Oleh',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onDibuatOlehChanged(value ?? ''),
          ),
        ],
      ),
    );
  }
}
