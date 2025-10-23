import 'package:flutter/material.dart';
import '../../../../../../data/warga_data.dart';

class FilterChips extends StatelessWidget {
  final Map<String, String> selectedFilters;
  final Function(String, String) onFilterSelected;
  final bool Function(String, String) isFilterSelected;

  const FilterChips({
    super.key,
    required this.selectedFilters,
    required this.onFilterSelected,
    required this.isFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Status Keluarga
        _buildFilterSection(
          title: "Status Keluarga",
          icon: Icons.group_outlined,
          filters: const ['Aktif', 'Non-Aktif', 'Pindah'],
          filterKey: 'status',
          selectedColor: Colors.blue,
        ),
        
        const SizedBox(height: 24),
        
        // Filter Status Kepemilikan Rumah
        _buildFilterSection(
          title: "Status Kepemilikan Rumah",
          icon: Icons.house_siding_outlined,
          filters: const ['Milik Sendiri', 'Kontrak', 'Keluarga', 'Lainnya'],
          filterKey: 'rumah',
          selectedColor: Colors.green,
        ),
        
        const SizedBox(height: 24),
        
        // Filter Nama Keluarga (dari data)
        _buildKeluargaSection(),
      ],
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required List<String> filters,
    required String filterKey,
    required Color selectedColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: selectedColor, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filters.map((filter) {
            final isSelected = isFilterSelected(filterKey, filter);
            return FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => onFilterSelected(filterKey, filter),
              backgroundColor: Colors.grey[100],
              selectedColor: selectedColor,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? selectedColor : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeluargaSection() {
    // Ambil daftar nama keluarga dari data
    final keluargaList = WargaData.dataKeluarga
        .map<String>((keluarga) => keluarga['nama_keluarga'] as String)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.family_restroom_outlined, color: Colors.orange, size: 18),
            const SizedBox(width: 8),
            const Text(
              "Nama Keluarga",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: keluargaList.map((keluarga) {
            final isSelected = isFilterSelected('nama', keluarga);
            return FilterChip(
              label: Text(
                keluarga,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => onFilterSelected('nama', keluarga),
              backgroundColor: Colors.grey[100],
              selectedColor: Colors.orange,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.orange : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}