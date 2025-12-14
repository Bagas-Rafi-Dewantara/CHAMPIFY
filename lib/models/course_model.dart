class Course {
  final int idCourse;
  final String namaCourse;
  final String linkGambar;
  final int jumlahLesson;
  final String durasiCourse;
  final String deskripsiCourse;
  final double hargaRegular;
  final double hargaPremium;

  Course({
    required this.idCourse,
    required this.namaCourse,
    required this.linkGambar,
    required this.jumlahLesson,
    required this.durasiCourse,
    required this.deskripsiCourse,
    required this.hargaRegular,
    required this.hargaPremium,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      idCourse: map['id_course'],
      namaCourse: map['nama_course'],
      linkGambar: map['link_gambar'],
      jumlahLesson: map['jumlah_lesson'],
      durasiCourse: map['durasi_course'],
      deskripsiCourse: map['deskripsi_course'],
      hargaRegular: (map['harga_reguler'] as num).toDouble(),
      hargaPremium: (map['harga_premium'] as num).toDouble(),
    );
  }
}
