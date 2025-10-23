import 'package:flutter/material.dart';
import '../../../services/toast_service.dart';

class RumahDelete {
  static Future<bool> showDeleteConfirmationDialog({
    required BuildContext context,
    required String alamat,
    required VoidCallback onConfirmDelete,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Konfirmasi Hapus'),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus rumah dengan alamat:\n"$alamat"?\n\nTindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static void deleteRumah({
    required BuildContext context,
    required Map<String, dynamic> rumah,
    required VoidCallback onSuccess,
  }) {
    // TODO: Implementasi logika hapus data dari database
    
    print('Menghapus rumah: ${rumah['alamat']}');

    _simulateDeleteProcess().then((_) {
      ToastService.showSuccess(context, "Data rumah berhasil dihapus");
      onSuccess();
    }).catchError((error) {
      ToastService.showError(context, "Gagal menghapus data rumah");
      print('Error deleting rumah: $error');
    });
  }

  static Future<void> _simulateDeleteProcess() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}