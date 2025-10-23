import 'package:flutter/material.dart';
import '../../../../data/warga_data.dart';
import 'list_content.dart';

class KeluargaList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const KeluargaList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<KeluargaList> createState() => _KeluargaListState();
}

class _KeluargaListState extends State<KeluargaList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allKeluarga = WargaData.dataKeluarga;

    if (widget.filters.isEmpty) return allKeluarga;

    return allKeluarga.where((keluarga) {
      // Filter nama (nama_keluarga atau kepala_keluarga)
      if (widget.filters.containsKey('nama') &&
          widget.filters['nama']!.isNotEmpty) {
        final searchTerm = widget.filters['nama']!.toLowerCase();
        final namaKeluarga = keluarga['nama_keluarga'].toString().toLowerCase();
        final kepalaKeluarga = keluarga['kepala_keluarga'].toString().toLowerCase();
        
        if (!namaKeluarga.contains(searchTerm) && 
            !kepalaKeluarga.contains(searchTerm)) {
          return false;
        }
      }

      // Filter status
      if (widget.filters.containsKey('status') &&
          widget.filters['status']!.isNotEmpty &&
          keluarga['status'] != widget.filters['status']) {
        return false;
      }

      // Filter status kepemilikan rumah
      if (widget.filters.containsKey('rumah') &&
          widget.filters['rumah']!.isNotEmpty &&
          keluarga['status_kepemilikan'] != widget.filters['rumah']) {
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
      totalKeluarga: filteredData.length,
    );
  }
}