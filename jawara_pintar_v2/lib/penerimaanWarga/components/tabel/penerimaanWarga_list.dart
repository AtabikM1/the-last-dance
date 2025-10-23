import 'package:flutter/material.dart';
import '../../../../data/penerimaan_warga_data.dart';
import 'list_content.dart';

class PenerimaanList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const PenerimaanList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<PenerimaanList> createState() => _PenerimaanListState();
}

class _PenerimaanListState extends State<PenerimaanList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allData = PenerimaanWargaData.semuaDataPendaftaran;

    if (widget.filters.isEmpty) return allData;

    return allData.where((data) {
      if (widget.filters.containsKey('nama') &&
          widget.filters['nama']!.isNotEmpty &&
          !data['nama'].toString().toLowerCase().contains(widget.filters['nama']!.toLowerCase())) {
        return false;
      }

      if (widget.filters.containsKey('jenis_kelamin') &&
          widget.filters['jenis_kelamin']!.isNotEmpty &&
          data['jenis_kelamin'] != widget.filters['jenis_kelamin']) {
        return false;
      }

      if (widget.filters.containsKey('status') &&
          widget.filters['status']!.isNotEmpty &&
          data['status_registrasi'] != widget.filters['status']) {
        return false;
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredData;

    return ListContent(
      filteredData: filteredData,
      scrollController: widget.scrollController,
      totalPendaftaran: filteredData.length,
    );
  }
}