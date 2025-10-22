import 'package:flutter/material.dart';
import '../../sidebar/sidebar.dart';
import 'komponen/form_tambah_pengguna.dart';

class UserAddScreen extends StatelessWidget {
  const UserAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jawara Pintar.'),
      ),
      drawer: const Sidebar(userEmail: "admin@jawara.com"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 500, // posisi card tetap di kiri
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Tambah Akun Pengguna',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const UserAddForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
