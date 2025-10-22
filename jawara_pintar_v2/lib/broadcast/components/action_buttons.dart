import 'package:flutter/material.dart';

class ActionPopupMenu extends StatelessWidget {
  const ActionPopupMenu({super.key, this.onDetail, this.onEdit, this.onDelete});

  final VoidCallback? onDetail;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuEntry<String>> menuItems = [];

    if (onDetail != null) {
      menuItems.add(
        PopupMenuItem(
          value: 'detail',
          onTap: onDetail,
          child: const Text('Detail'),
        ),
      );
    }

    if (onEdit != null) {
      menuItems.add(
        PopupMenuItem(value: 'edit', onTap: onEdit, child: const Text('Edit')),
      );
    }

    if (menuItems.isNotEmpty && onDelete != null) {
      menuItems.add(const PopupMenuDivider());
    }

    if (onDelete != null) {
      menuItems.add(
        PopupMenuItem(
          value: 'delete',
          onTap: onDelete,
          child: Text(
            'Hapus',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    if (menuItems.isEmpty) {
      return const IconButton(
        icon: Icon(Icons.more_vert),
        tooltip: 'Tidak ada aksi',
        onPressed: null,
      );
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'Aksi Lainnya',
      itemBuilder: (BuildContext context) {
        return menuItems;
      },
    );
  }
}
