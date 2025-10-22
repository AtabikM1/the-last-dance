class DataAspirasi {
  static final List<String> StatusAspirasi = ['Diterima', 'Ditolak', 'Pending'];

  static final List<Map<String, dynamic>> dataAspirasi = [
    {
      "judul": "Perbaikan Jalan Utama",
      "deskripsi":
          "Mohon diperbaiki jalan berlubang di depan kantor kelurahan.",
      "status": "Diterima",
      "dibuat_oleh": "Andi Saputra",
      "tanggal_dibuat": "10 Oktober 2025",
    },
    {
      "judul": "Lampu Jalan Mati",
      "deskripsi": "Lampu jalan di RT 02 RW 05 mati sejak seminggu lalu.",
      "status": "Pending",
      "dibuat_oleh": "Rina Kartika",
      "tanggal_dibuat": "11 Oktober 2025",
    },
    {
      "judul": "Sampah Menumpuk",
      "deskripsi": "Tempat sampah umum penuh dan belum diangkut.",
      "status": "Pending",
      "dibuat_oleh": "Budi Santoso",
      "tanggal_dibuat": "12 Oktober 2025",
    },
    {
      "judul": "Air Tidak Mengalir",
      "deskripsi": "Sudah 2 hari air PDAM tidak mengalir di wilayah kami.",
      "status": "Diterima",
      "dibuat_oleh": "Siti Rahmawati",
      "tanggal_dibuat": "13 Oktober 2025",
    },
    {
      "judul": "Trotoar Rusak",
      "deskripsi":
          "Trotoar depan sekolah retak dan berbahaya untuk pejalan kaki.",
      "status": "Ditolak",
      "dibuat_oleh": "Rizky Hidayat",
      "tanggal_dibuat": "14 Oktober 2025",
    },
    {
      "judul": "Kebersihan Taman",
      "deskripsi": "Taman kota terlihat kotor dan tidak terawat.",
      "status": "Diterima",
      "dibuat_oleh": "Lina Marlina",
      "tanggal_dibuat": "15 Oktober 2025",
    },
    {
      "judul": "Parkir Sembarangan",
      "deskripsi":
          "Banyak kendaraan parkir di bahu jalan hingga menutup akses.",
      "status": "Pending",
      "dibuat_oleh": "Dedi Pratama",
      "tanggal_dibuat": "16 Oktober 2025",
    },
  ];

  static List<Map<String, dynamic>> get semuaDataAspirasi {
    List<Map<String, dynamic>> semuaAspirasi = [];
    for (var aspirasi in dataAspirasi) {
      semuaAspirasi.add(Map<String, dynamic>.from(aspirasi));
    }
    return semuaAspirasi;
  }

  static Map<String, dynamic>? getAspirasiByJudul(String judulAspirasi) {
    try {
      return dataAspirasi.firstWhere(
        (aspirasi) => aspirasi['judul'] == judulAspirasi,
      );
    } catch (e) {
      return null;
    }
  }
}
