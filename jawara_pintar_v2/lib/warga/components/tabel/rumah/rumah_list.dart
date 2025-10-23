import 'package:flutter/material.dart';
import '../../../../data/rumah_data.dart';
import 'list_content.dart';

class RumahList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const RumahList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<RumahList> createState() => _RumahListState();
}

class _RumahListState extends State<RumahList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allRumah = RumahData.semuaDataRumah;

    if (widget.filters.isEmpty) return allRumah;

    return allRumah.where((rumah) {
      if (widget.filters.containsKey('alamat') &&
          widget.filters['alamat']!.isNotEmpty &&
          !rumah['alamat'].toString().toLowerCase().contains(widget.filters['alamat']!.toLowerCase())) {
        return false;
      }

      if (widget.filters.containsKey('status') &&
          widget.filters['status']!.isNotEmpty &&
          rumah['status'] != widget.filters['status']) {
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
      totalRumah: filteredData.length,
    );
  }
}