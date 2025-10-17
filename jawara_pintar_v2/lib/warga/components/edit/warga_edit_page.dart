import 'package:flutter/material.dart';
import 'fields/nama_lengkap_field.dart';
import 'fields/nik_field.dart';
import 'fields/no_telepon_field.dart';
import 'fields/keluarga_field.dart';
import 'fields/tempat_lahir_field.dart';
import 'fields/tanggal_lahir_field.dart';
import 'fields/agama_field.dart';
import 'fields/golongan_darah_field.dart';
import 'fields/peran_field.dart';
import 'fields/pendidikan_field.dart';
import 'fields/pekerjaan_field.dart';
import 'fields/status_hidup_field.dart';
import 'fields/status_penduduk_field.dart';
import 'fields/jenis_kelamin_field.dart';
import '../../../services/toast_service.dart';

class WargaEditPage extends StatefulWidget {
  final Map<String, dynamic> warga;

  const WargaEditPage({
    super.key,
    required this.warga,
  });

  @override
  State<WargaEditPage> createState() => _WargaEditPageState();
}

class _WargaEditPageState extends State<WargaEditPage> {
  final _formKey = GlobalKey<FormState>();

  late String _nama;
  late String _nik;
  late String _noTelepon;
  late String _keluarga;
  late String _tempatLahir;
  late String _tanggalLahir;
  late String _agama;
  late String _golonganDarah;
  late String _peran;
  late String _pendidikan;
  late String _pekerjaan;
  late String _statusHidup;
  late String _statusPenduduk;
  late String _jenisKelamin;

  @override
  void initState() {
    super.initState();
    _nama = widget.warga['nama'];
    _nik = widget.warga['nik'];
    _noTelepon = widget.warga['no_telepon'] ?? '082141744866';
    _keluarga = widget.warga['keluarga'];
    _tempatLahir = widget.warga['tempat_lahir'] ?? '';
    _tanggalLahir = widget.warga['tanggal_lahir'] ?? '';
    _agama = widget.warga['agama'] ?? '';
    _golonganDarah = widget.warga['golongan_darah'] ?? '';
    _peran = widget.warga['peran'] ?? 'Kepala Keluarga';
    _pendidikan = widget.warga['pendidikan'] ?? '';
    _pekerjaan = widget.warga['pekerjaan'] ?? '';
    _statusHidup = widget.warga['status_hidup'] ?? 'Hidup';
    _statusPenduduk = widget.warga['status_domisili'] ?? 'Aktif';
    _jenisKelamin = widget.warga['jenis_kelamin'] ?? 'Laki-laki';
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // TODO: simpan data ke database atau state management
      print('Data disimpan:');
      print('Nama: $_nama');
      print('NIK: $_nik');
      print('No Telepon: $_noTelepon');
      print('Keluarga: $_keluarga');
      print('Tempat Lahir: $_tempatLahir');
      print('Tanggal Lahir: $_tanggalLahir');
      print('Agama: $_agama');
      print('Golongan Darah: $_golonganDarah');
      print('Peran: $_peran');
      print('Pendidikan: $_pendidikan');
      print('Pekerjaan: $_pekerjaan');
      print('Status Hidup: $_statusHidup');
      print('Status Penduduk: $_statusPenduduk');
      print('Jenis Kelamin: $_jenisKelamin');

      ToastService.showSuccess(context, "Data warga berhasil diperbarui");

      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Warga",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
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
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.edit, color: Colors.blue, size: 28),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Edit Warga",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Colors.grey),
                      const SizedBox(height: 24),

                      NamaLengkapField(
                        initialValue: _nama,
                        onSaved: (value) => _nama = value,
                      ),
                      NikField(
                        initialValue: _nik,
                        onSaved: (value) => _nik = value,
                      ),
                      NoTeleponField(
                        initialValue: _noTelepon,
                        onSaved: (value) => _noTelepon = value,
                      ),
                      KeluargaField(
                        value: _keluarga,
                        onChanged: (value) => setState(() => _keluarga = value),
                      ),
                      TempatLahirField(
                        initialValue: _tempatLahir,
                        onSaved: (value) => _tempatLahir = value,
                      ),
                      TanggalLahirField(
                        value: _tanggalLahir,
                        onDateSelected: (date) => setState(() => _tanggalLahir = date),
                      ),
                      AgamaField(
                        value: _agama,
                        onChanged: (value) => setState(() => _agama = value),
                      ),
                      GolonganDarahField(
                        value: _golonganDarah,
                        onChanged: (value) => setState(() => _golonganDarah = value),
                      ),
                      PeranField(
                        value: _peran,
                        onChanged: (value) => setState(() => _peran = value),
                      ),
                      PendidikanField(
                        value: _pendidikan,
                        onChanged: (value) => setState(() => _pendidikan = value),
                      ),
                      PekerjaanField(
                        value: _pekerjaan,
                        onChanged: (value) => setState(() => _pekerjaan = value),
                      ),
                      StatusHidupField(
                        value: _statusHidup,
                        onChanged: (value) => setState(() => _statusHidup = value),
                      ),
                      StatusPendudukField(
                        value: _statusPenduduk,
                        onChanged: (value) => setState(() => _statusPenduduk = value),
                      ),
                      JenisKelaminField(
                        value: _jenisKelamin,
                        onChanged: (value) => setState(() => _jenisKelamin = value),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Batal"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
    );
  }
}