import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/kegiatan_data.dart';
import 'filter_header.dart';
import 'filter_button.dart';

class FilterKegiatanDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterKegiatanDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterKegiatanDialog> createState() => _FilterKegiatanDialogState();
}

class _FilterKegiatanDialogState extends State<FilterKegiatanDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedNama = '';
  String? _selectedKategori;
  String? _selectedTanggal;
  String? _selectedPenanggungJawab;

  void _applyFilter() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final filters = <String, String>{};
      if (_selectedNama.isNotEmpty) filters['nama'] = _selectedNama;
      if (_selectedKategori != null) filters['kategori'] = _selectedKategori!;
      if (_selectedTanggal != null) filters['tanggal'] = _selectedTanggal!;
      if (_selectedPenanggungJawab != null) {
        filters['penanggungJawab'] = _selectedPenanggungJawab!;
      }

      widget.onFilterApplied(filters);
      Navigator.of(context).pop();
    }
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedNama = '';
      _selectedKategori = null;
      _selectedTanggal = null;
      _selectedPenanggungJawab = null;
    });
    widget.onFilterReset();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedTanggal = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterHeader(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildFormFields(),
              const SizedBox(height: 24),
              FilterButtons(onReset: _resetFilter, onApply: _applyFilter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Nama Kegiatan',
            hintText: 'Contoh: Donor Darah Bersama PMI',
          ),
          onChanged: (value) => setState(() => _selectedNama = value),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Kategori Kegiatan',
            hintText: '-- Pilih Kategori --',
          ),
          value: _selectedKategori,
          items: KegiatanData.kategoriKegiatan.map((kategori) {
            return DropdownMenuItem(value: kategori, child: Text(kategori));
          }).toList(),
          onChanged: (value) => setState(() => _selectedKategori = value),
        ),
        const SizedBox(height: 16),

        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Tanggal Pelaksanaan',
            hintText: 'Pilih tanggal kegiatan',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _selectDate,
            ),
          ),
          controller: TextEditingController(text: _selectedTanggal ?? ''),
        ),
        const SizedBox(height: 16),

        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Penanggung Jawab',
            hintText: 'Contoh: Pak Dedi, Bu Lina...',
          ),
          onChanged: (value) =>
              setState(() => _selectedPenanggungJawab = value),
        ),
      ],
    );
  }
}
