import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/data_aspirasi.dart';

class AspirasiEditPage extends StatefulWidget {
  final Map<String, dynamic>? aspirasi;
  const AspirasiEditPage({super.key, this.aspirasi});

  @override
  State<AspirasiEditPage> createState() => _AspirasiEditPage();
}

class _AspirasiEditPage extends State<AspirasiEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Field data
  String _judul = '';
  String _deskripsi = '';
  String? _status;
  String _dibuat_oleh = '';
  DateTime? _tanggal_dibuat;

  List<String> get _statusList => DataAspirasi.StatusAspirasi;

  @override
  void initState() {
    super.initState();
    if (widget.aspirasi != null) {
      final data = widget.aspirasi!;
      _judul = data['judul'] ?? '';
      _deskripsi = data['deskripsi'] ?? '';
      _status = data['status'] ?? '';
      _dibuat_oleh = data['dibuat_oleh'] ?? '';
      if (data['tanggal_dibuat'] != null && data['tanggal_dibuat'] != '') {
        _tanggal_dibuat = DateFormat(
          'd MMMM yyyy',
          'id_ID',
        ).parse(data['tanggal_dibuat']);
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final tanggalFormatted = _tanggal_dibuat != null
          ? DateFormat('d MMMM yyyy', 'id_ID').format(_tanggal_dibuat!)
          : '';

      final newData = {
        "judul": _judul,
        "deskripsi": _deskripsi,
        "status": _status,
        "dibuat_oleh": _dibuat_oleh,
        "tanggal_dibuat": tanggalFormatted,
      };

      print("=== Data Broadcast ===");
      print(newData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Broadcast berhasil disimpan!')),
      );
      Navigator.pop(context, newData);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: _tanggal_dibuat ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggal_dibuat = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanggalController = TextEditingController(
      text: _tanggal_dibuat != null
          ? DateFormat('d MMMM yyyy', 'id_ID').format(_tanggal_dibuat!)
          : '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.aspirasi == null ? "Tambah Aspirasi" : "Edit Aspirasi",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Judul"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _judul,
                    decoration: const InputDecoration(
                      hintText: "Contoh: Aspal Rusak",
                    ),
                    onSaved: (value) => _judul = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? "Judul wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Deskripsi"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _deskripsi,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Tuliskan isi deskripsi aspirasi...",
                    ),
                    onSaved: (value) => _deskripsi = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? "Isi pesan wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Status"),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      hintText: "-- Pilih Status --",
                    ),
                    items: _statusList.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Pilih Status kegiatan" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Dibuat Oleh"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _dibuat_oleh,
                    decoration: const InputDecoration(
                      hintText: "Contoh: Admin Jawara",
                    ),
                    onSaved: (value) => _dibuat_oleh = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? "Nama pembuat wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Tanggal Publikasi"),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: tanggalController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "--/--/----",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: _selectDate,
                      ),
                    ),
                    validator: (_) =>
                        _tanggal_dibuat == null ? "Tanggal wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => _formKey.currentState!.reset(),
                        child: const Text("Reset"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Simpan"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
