import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/data_aspirasi.dart';
import 'filter_header.dart';
import 'filter_button.dart';

class FilterAspirasiDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterAspirasiDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterAspirasiDialog> createState() => _FilterAspirasiDialog();
}

class _FilterAspirasiDialog extends State<FilterAspirasiDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedJudul = '';
  String? _selectedStatus;

  void _applyFilter() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final filters = <String, String>{};
      if (_selectedJudul.isNotEmpty) filters['judul'] = _selectedJudul;
      if (_selectedStatus != null) filters['status'] = _selectedStatus!;

      widget.onFilterApplied(filters);
      Navigator.of(context).pop();
    }
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedJudul = '';
      _selectedStatus = null;
    });
    widget.onFilterReset();
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
            labelText: 'Judul Broadcast',
            hintText: 'Contoh: Pengumuman',
          ),
          onChanged: (value) => setState(() => _selectedJudul = value),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Status Aspirasi',
            hintText: '-- Pilih Status --',
          ),
          value: _selectedStatus,
          items: DataAspirasi.StatusAspirasi.map((aspirasi) {
            return DropdownMenuItem(value: aspirasi, child: Text(aspirasi));
          }).toList(),
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
