import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/data/data_aspirasi.dart';
import '../../../data/data_broadcast.dart';

class FormAspirasi extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final GlobalKey<FormState> formKey;
  final Function(String) onJudulChanged;
  final Function(String) onDeskripsiChanged;
  final Function(String) onStatusChanged;
  final Function(String) onDibuatOlehChanged;
  final Function(String) onTanggalDibuatChanged;

  const FormAspirasi({
    super.key,
    required this.initialData,
    required this.formKey,
    required this.onJudulChanged,
    required this.onDeskripsiChanged,
    required this.onStatusChanged,
    required this.onDibuatOlehChanged,
    required this.onTanggalDibuatChanged,
  });

  @override
  State<FormAspirasi> createState() => _FormAspirasiState();
}

class _FormAspirasiState extends State<FormAspirasi> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _dibuatOlehController;
  late TextEditingController _tanggalDibuatController;

  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.initialData['judul'] ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.initialData['deskripsi'] ?? '',
    );
    _dibuatOlehController = TextEditingController(
      text: widget.initialData['dibuat_oleh'] ?? '',
    );
    _tanggalDibuatController = TextEditingController(
      text: widget.initialData['tanggal_dibuat'] ?? '',
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _dibuatOlehController.dispose();
    _tanggalDibuatController.dispose();
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
        _tanggalDibuatController.text = formattedDate;
      });
      widget.onTanggalDibuatChanged(formattedDate);
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
          TextFormField(
            controller: _judulController,
            decoration: const InputDecoration(
              labelText: 'Judul Aspirasi',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onJudulChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _deskripsiController,
            decoration: const InputDecoration(
              labelText: 'Isi Pesan',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onSaved: (value) => widget.onDeskripsiChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: selectedStatus,
            items: DataAspirasi.StatusAspirasi.map(
              (status) => DropdownMenuItem(value: status, child: Text(status)),
            ).toList(),
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => selectedStatus = value);
              if (value != null) widget.onStatusChanged(value);
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _dibuatOlehController,
            decoration: const InputDecoration(
              labelText: 'Dibuat Oleh',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onDibuatOlehChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _tanggalDibuatController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Tanggal Publikasi',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pilihTanggal(context),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
