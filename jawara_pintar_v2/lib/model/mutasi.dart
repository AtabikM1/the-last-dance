class Mutasi {
  final String id;
  final String tanggal;
  final String namaKeluarga;
  final String jenisMutasi; // "Keluar Wilayah" atau "Pindah Rumah"
  final String alamatLama;
  final String alamatBaru;
  final String alasan;

  Mutasi({
    required this.id,
    required this.tanggal,
    required this.namaKeluarga,
    required this.jenisMutasi,
    required this.alamatLama,
    required this.alamatBaru,
    required this.alasan,
  });
}