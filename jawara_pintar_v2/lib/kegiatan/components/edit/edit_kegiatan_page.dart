import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/kegiatan_data.dart';

class KegiatanEditPage extends StatefulWidget {
  final Map<String, dynamic> kegiatan;
  const KegiatanEditPage({super.key, required this.kegiatan});

  @override
  State<KegiatanEditPage> createState() => _KegiatanEditPageState();
}

class _KegiatanEditPageState extends State<KegiatanEditPage> {
  final _formKey = GlobalKey<FormState>();

  String _namaKegiatan = '';
  String? _kategoriKegiatan;
  DateTime? _tanggalPelaksanaan;
  String _lokasi = '';
  String _penanggungJawab = '';
  String _deskripsi = '';

  List<String> get _kategoriList => KegiatanData.kategoriKegiatan;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final tanggalFormatted = _tanggalPelaksanaan != null
          ? DateFormat('d MMMM yyyy', 'id_ID').format(_tanggalPelaksanaan!)
          : '';

      print('Nama: $_namaKegiatan');
      print('Kategori: $_kategoriKegiatan');
      print('Tanggal: $tanggalFormatted');
      print('Lokasi: $_lokasi');
      print('Penanggung Jawab: $_penanggungJawab');
      print('Deskripsi: $_deskripsi');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data kegiatan berhasil disimpan!')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      _namaKegiatan = '';
      _kategoriKegiatan = null;
      _tanggalPelaksanaan = null;
      _lokasi = '';
      _penanggungJawab = '';
      _deskripsi = '';
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: _tanggalPelaksanaan ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalPelaksanaan = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanggalController = TextEditingController(
      text: _tanggalPelaksanaan != null
          ? DateFormat('d MMMM yyyy', 'id_ID').format(_tanggalPelaksanaan!)
          : '',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Kegiatan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
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
                  const Text("Nama Kegiatan"),
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Contoh: Musyawarah Warga",
                    ),
                    onSaved: (value) => _namaKegiatan = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? "Nama kegiatan wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Kategori Kegiatan"),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _kategoriKegiatan,
                    decoration: const InputDecoration(
                      hintText: "-- Pilih Kategori --",
                    ),
                    items: _kategoriList.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _kategoriKegiatan = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Pilih kategori kegiatan" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Tanggal"),
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
                    validator: (_) => _tanggalPelaksanaan == null
                        ? "Tanggal wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Lokasi"),
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Contoh: Balai RT 03",
                    ),
                    onSaved: (value) => _lokasi = value ?? '',
                  ),
                  const SizedBox(height: 16),

                  const Text("Penanggung Jawab"),
                  const SizedBox(height: 4),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Contoh: Pak RT atau Bu RW",
                    ),
                    onSaved: (value) => _penanggungJawab = value ?? '',
                  ),
                  const SizedBox(height: 16),

                  const Text("Deskripsi"),
                  const SizedBox(height: 4),
                  TextFormField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          "Tuliskan detail event seperti agenda, keperluan, dll.",
                    ),
                    onSaved: (value) => _deskripsi = value ?? '',
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Reset"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Submit"),
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
