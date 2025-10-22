import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/kegiatan_data.dart';
import 'tabel_header.dart';
import 'tabel_content.dart';
import 'tabel_pagination.dart';

class TabelKegiatan extends StatefulWidget {
  final Map<String, String> filters;

  const TabelKegiatan({super.key, required this.filters});

  @override
  State<TabelKegiatan> createState() => _TabelKegiatanState();
}

class _TabelKegiatanState extends State<TabelKegiatan> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void didUpdateWidget(TabelKegiatan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filters != widget.filters) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allKegiatan = KegiatanData.semuaDataKegiatan;

    if (widget.filters.isEmpty) return allKegiatan;

    return allKegiatan.where((kegiatan) {
      if (widget.filters.containsKey('nama') &&
          widget.filters['nama']!.isNotEmpty &&
          !kegiatan['nama'].toString().toLowerCase().contains(
            widget.filters['nama']!.toLowerCase(),
          )) {
        return false;
      }

      if (widget.filters.containsKey('kategori') &&
          widget.filters['kategori']!.isNotEmpty &&
          kegiatan['kategori'] != widget.filters['kategori']) {
        return false;
      }

      if (widget.filters.containsKey('tanggal') &&
          widget.filters['tanggal']!.isNotEmpty) {
        try {
          DateTime kegiatanDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(kegiatan['tanggal']);
          DateTime filterDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(widget.filters['tanggal']!);

          if (kegiatanDate != filterDate) return false;
        } catch (e) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedData {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= _filteredData.length) return [];

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
    final filteredData = _filteredData;
    final paginatedData = _paginatedData;
    final showPagination = filteredData.length > _itemsPerPage;

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
          TabelHeaderKegiatan(totalKegiatan: filteredData.length),
          const SizedBox(height: 16),
          Expanded(
            child: TabelContent(
              filteredData: paginatedData,
              currentPage: _currentPage,
              itemsPerPage: _itemsPerPage,
            ),
          ),
          if (showPagination) ...[
            const SizedBox(height: 16),
            TabelPagination(
              currentPage: _currentPage,
              totalItems: filteredData.length,
              itemsPerPage: _itemsPerPage,
              onPageChanged: _onPageChanged,
            ),
          ],
        ],
      ),
    );
  }
}
