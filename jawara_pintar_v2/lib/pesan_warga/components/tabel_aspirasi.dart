import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/data_aspirasi.dart';
import 'tabel_header.dart';
import 'tabel_content.dart';
import 'tabel_pagination.dart';

class TabelAspirasi extends StatefulWidget {
  final Map<String, String> filters;

  const TabelAspirasi({super.key, required this.filters});

  @override
  State<TabelAspirasi> createState() => _TabelAspirasiState();
}

class _TabelAspirasiState extends State<TabelAspirasi> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void didUpdateWidget(TabelAspirasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filters != widget.filters) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allAspirasi = DataAspirasi.semuaDataAspirasi;

    if (widget.filters.isEmpty) return allAspirasi;

    return allAspirasi.where((aspirasi) {
      if (widget.filters.containsKey('dibuat_oleh') &&
          widget.filters['dibuat_oleh']!.isNotEmpty &&
          !aspirasi['dibuat_oleh'].toString().toLowerCase().contains(
            widget.filters['dibuat_oleh']!.toLowerCase(),
          )) {
        return false;
      }

      if (widget.filters.containsKey('judul') &&
          widget.filters['judul']!.isNotEmpty &&
          aspirasi['judul'] != widget.filters['judul']) {
        return false;
      }

      if (widget.filters.containsKey('status') &&
          widget.filters['status']!.isNotEmpty &&
          aspirasi['status'] != widget.filters['status']) {
        return false;
      }

      if (widget.filters.containsKey('tanggal_dibuat') &&
          widget.filters['tanggal_dibuat']!.isNotEmpty) {
        try {
          DateTime kegiatanDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(aspirasi['tanggal_dibuat']);
          DateTime filterDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(widget.filters['tanggal_dibuat']!);

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

    return SizedBox.expand(
      child: Container(
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
            TabelHeaderAspirasi(totalAspirasi: filteredData.length),
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
      ),
    );
  }
}
