import 'package:flutter/material.dart';
import '../../../data/warga_data.dart';
import 'tabel_header.dart';
import 'tabel_content.dart';
import 'tabel_pagination.dart';

class TabelWarga extends StatefulWidget {
  final Map<String, String> filters;

  const TabelWarga({super.key, required this.filters});

  @override
  State<TabelWarga> createState() => _TabelWargaState();
}

class _TabelWargaState extends State<TabelWarga> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  List<Map<String, dynamic>> get _filteredData {
    if (widget.filters.isEmpty) return WargaData.dataWarga;

    return WargaData.dataWarga.where((warga) {
      if (widget.filters.containsKey('nama') &&
          !warga['nama'].toString().toLowerCase().contains(widget.filters['nama']!.toLowerCase())) {
        return false;
      }
      if (widget.filters.containsKey('jenis_kelamin') &&
          warga['jenis_kelamin'] != widget.filters['jenis_kelamin']) {
        return false;
      }
      if (widget.filters.containsKey('status') &&
          warga['status_domisili'] != widget.filters['status']) {
        return false;
      }
      if (widget.filters.containsKey('keluarga') &&
          warga['keluarga'] != widget.filters['keluarga']) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedData {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    
    if (startIndex >= _filteredData.length) {
      return [];
    }
    
    return _filteredData.sublist(
      startIndex,
      endIndex.clamp(0, _filteredData.length),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showPagination = _filteredData.length > _itemsPerPage;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TabelHeader(totalWarga: _filteredData.length),
          const SizedBox(height: 16),
          TabelContent(filteredData: _paginatedData),
          if (showPagination) ...[
            const SizedBox(height: 16),
            TabelPagination(
              currentPage: _currentPage,
              totalItems: _filteredData.length,
              itemsPerPage: _itemsPerPage,
              onPageChanged: _onPageChanged,
            ),
          ],
        ],
      ),
    );
  }
}