import 'package:flutter/material.dart';

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
        // Filter Status Rumah
        _buildFilterSection(
          title: "Status Rumah",
          icon: Icons.home_work_outlined,
          filters: const ['Ditempati', 'Tersedia', 'Dalam Perbaikan'],
          filterKey: 'status',
          selectedColor: Colors.blue,
        ),
        
        const SizedBox(height: 24),
        
        // Filter Status Kepemilikan
        _buildFilterSection(
          title: "Status Kepemilikan",
          icon: Icons.house_siding_outlined,
          filters: const ['Milik Sendiri', 'Kontrak', 'Kos', 'Lainnya'],
          filterKey: 'kepemilikan',
          selectedColor: Colors.green,
        ),
        
        const SizedBox(height: 24),
        
        // Filter Jumlah Penghuni
        _buildFilterSection(
          title: "Jumlah Penghuni",
          icon: Icons.people_outline,
          filters: const ['0', '1-3', '4-6', '7+'],
          filterKey: 'penghuni',
          selectedColor: Colors.orange,
        ),
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
}