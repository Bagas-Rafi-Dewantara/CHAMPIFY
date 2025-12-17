import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil state Dark Mode
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    // 2. Tentukan Warna
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.grey[400] : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE89B8E).withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE89B8E).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: Color(0xFFE89B8E),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terakhir diperbarui: 16 Desember 2025',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Harap baca dengan saksama sebelum menggunakan layanan CHAMPIFY',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 1. Pendahuluan
              _buildSection(
                number: '1',
                title: 'Pendahuluan',
                content:
                    'Selamat datang di CHAMPIFY. Dengan mengakses atau menggunakan aplikasi CHAMPIFY, Anda setuju untuk terikat dengan Syarat dan Ketentuan ini. Jika Anda tidak setuju dengan salah satu bagian dari ketentuan ini, mohon untuk tidak menggunakan layanan kami.\n\n'
                    'CHAMPIFY adalah platform pembelajaran yang menyediakan kursus online, kompetisi edukatif, dan layanan mentoring untuk membantu pengguna mengembangkan keterampilan dan pengetahuan mereka.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 2. Akun Pengguna
              _buildSection(
                number: '2',
                title: 'Akun Pengguna',
                content:
                    'Untuk mengakses fitur tertentu dari layanan kami, Anda harus membuat akun. Anda bertanggung jawab untuk:\n\n'
                    '• Menjaga kerahasiaan informasi akun Anda\n'
                    '• Semua aktivitas yang terjadi di bawah akun Anda\n'
                    '• Memberikan informasi yang akurat dan lengkap\n'
                    '• Memperbarui informasi akun Anda secara berkala\n\n'
                    'Anda harus segera memberi tahu kami jika terjadi penggunaan tidak sah terhadap akun Anda.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 3. Penggunaan Layanan
              _buildSection(
                number: '3',
                title: 'Penggunaan Layanan',
                content:
                    'Anda setuju untuk menggunakan layanan CHAMPIFY hanya untuk tujuan yang sah dan sesuai dengan ketentuan ini. Anda tidak diperbolehkan:\n\n'
                    '• Melanggar hukum atau peraturan yang berlaku\n'
                    '• Mengganggu atau merusak layanan atau server\n'
                    '• Menyalahgunakan atau mengeksploitasi konten\n'
                    '• Menggunakan bot atau alat otomatis tanpa izin\n'
                    '• Berbagi akun dengan pihak lain\n'
                    '• Menyalin atau mendistribusikan materi tanpa izin',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 4. Konten Kursus
              _buildSection(
                number: '4',
                title: 'Konten Kursus',
                content:
                    'Semua materi kursus, termasuk video, teks, gambar, dan materi lainnya adalah milik CHAMPIFY atau pemberi lisensi kami dan dilindungi oleh hak cipta.\n\n'
                    'Anda diberikan lisensi terbatas untuk mengakses dan menggunakan konten kursus untuk keperluan pembelajaran pribadi. Anda tidak boleh:\n\n'
                    '• Merekam, mengunduh, atau mendistribusikan ulang konten\n'
                    '• Menggunakan konten untuk tujuan komersial\n'
                    '• Memodifikasi atau membuat karya turunan',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 5. Pembayaran dan Pengembalian Dana
              _buildSection(
                number: '5',
                title: 'Pembayaran dan Pengembalian Dana',
                content:
                    'Beberapa layanan kami memerlukan pembayaran. Dengan melakukan pembayaran, Anda setuju:\n\n'
                    '• Memberikan informasi pembayaran yang akurat\n'
                    '• Membayar semua biaya yang berlaku\n'
                    '• Bahwa semua pembayaran bersifat final\n\n'
                    'Pengembalian dana dapat diberikan dalam kondisi tertentu:\n'
                    '• Dalam 7 hari setelah pembelian jika belum mengakses >20% materi\n'
                    '• Jika terjadi kesalahan teknis dari pihak kami\n'
                    '• Sesuai kebijakan pengembalian dana yang berlaku',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 6. Kompetisi
              _buildSection(
                number: '6',
                title: 'Kompetisi',
                content:
                    'Partisipasi dalam kompetisi di CHAMPIFY tunduk pada aturan tambahan:\n\n'
                    '• Anda harus mengikuti semua aturan kompetisi\n'
                    '• Tidak boleh melakukan kecurangan atau manipulasi\n'
                    '• Keputusan juri bersifat final\n'
                    '• Hadiah akan diberikan sesuai ketentuan kompetisi\n'
                    '• CHAMPIFY berhak mendiskualifikasi peserta yang melanggar aturan',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 7. Layanan Mentoring
              _buildSection(
                number: '7',
                title: 'Layanan Mentoring',
                content:
                    'Layanan mentoring disediakan oleh mentor independen melalui platform CHAMPIFY:\n\n'
                    '• Jadwal sesi harus disetujui oleh kedua belah pihak\n'
                    '• Pembatalan harus dilakukan minimal 24 jam sebelumnya\n'
                    '• CHAMPIFY tidak bertanggung jawab atas kualitas saran mentor\n'
                    '• Anda harus bersikap profesional dan hormat\n'
                    '• Pelanggaran dapat mengakibatkan penangguhan layanan',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 8. Hak Kekayaan Intelektual
              _buildSection(
                number: '8',
                title: 'Hak Kekayaan Intelektual',
                content:
                    'Semua hak kekayaan intelektual dalam layanan dan konten kami, termasuk tapi tidak terbatas pada:\n\n'
                    '• Merek dagang dan logo CHAMPIFY\n'
                    '• Desain dan tata letak aplikasi\n'
                    '• Kode sumber dan teknologi\n'
                    '• Konten kursus dan materi pembelajaran\n\n'
                    'adalah milik CHAMPIFY atau pemberi lisensi kami dan dilindungi oleh hukum kekayaan intelektual yang berlaku.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 9. Privasi Data
              _buildSection(
                number: '9',
                title: 'Privasi Data',
                content:
                    'Penggunaan data pribadi Anda diatur oleh Kebijakan Privasi kami. Dengan menggunakan layanan kami, Anda setuju bahwa kami dapat mengumpulkan, menggunakan, dan membagikan informasi Anda sesuai dengan Kebijakan Privasi.\n\n'
                    'Kami berkomitmen untuk melindungi privasi Anda dan menggunakan data Anda hanya untuk meningkatkan layanan kami.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 10. Penangguhan dan Penghentian
              _buildSection(
                number: '10',
                title: 'Penangguhan dan Penghentian',
                content:
                    'Kami berhak untuk menangguhkan atau menghentikan akses Anda ke layanan kami jika:\n\n'
                    '• Anda melanggar Syarat dan Ketentuan ini\n'
                    '• Anda terlibat dalam aktivitas penipuan atau ilegal\n'
                    '• Kami diminta oleh penegak hukum\n'
                    '• Untuk melindungi keamanan platform dan pengguna lain\n\n'
                    'Anda dapat menghentikan akun Anda kapan saja melalui pengaturan akun.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 11. Pembatasan Tanggung Jawab
              _buildSection(
                number: '11',
                title: 'Pembatasan Tanggung Jawab',
                content:
                    'CHAMPIFY dan afiliasinya tidak bertanggung jawab atas:\n\n'
                    '• Kerugian tidak langsung atau konsekuensial\n'
                    '• Kehilangan data atau keuntungan\n'
                    '• Gangguan layanan atau kesalahan teknis\n'
                    '• Konten atau tindakan pengguna lain\n'
                    '• Keputusan yang dibuat berdasarkan konten kami\n\n'
                    'Layanan disediakan "sebagaimana adanya" tanpa jaminan apa pun.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 12. Perubahan Ketentuan
              _buildSection(
                number: '12',
                title: 'Perubahan Ketentuan',
                content:
                    'Kami berhak untuk mengubah Syarat dan Ketentuan ini kapan saja. Perubahan akan berlaku segera setelah diposting di aplikasi.\n\n'
                    'Kami akan memberitahu Anda tentang perubahan signifikan melalui email atau notifikasi dalam aplikasi. Penggunaan berkelanjutan Anda terhadap layanan setelah perubahan berarti Anda menerima ketentuan yang diperbarui.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 13. Hukum yang Berlaku
              _buildSection(
                number: '13',
                title: 'Hukum yang Berlaku',
                content:
                    'Syarat dan Ketentuan ini diatur oleh dan ditafsirkan sesuai dengan hukum Republik Indonesia. Setiap perselisihan akan diselesaikan melalui pengadilan yang berwenang di Jakarta.\n\n'
                    'Sebelum mengambil tindakan hukum, para pihak setuju untuk berupaya menyelesaikan perselisihan melalui negosiasi atau mediasi.',
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // 14. Hubungi Kami
              _buildSection(
                number: '14',
                title: 'Hubungi Kami',
                content:
                    'Jika Anda memiliki pertanyaan tentang Syarat dan Ketentuan ini, silakan hubungi kami:\n\n'
                    '• Email: support@champify.com\n'
                    '• Telepon: +62 21 1234 5678\n'
                    '• Alamat: Jl. Pendidikan No. 123, Jakarta 12345\n\n'
                    'Tim dukungan kami tersedia Senin-Jumat, 09:00-17:00 WIB.',
                isDark: isDark,
              ),

              const SizedBox(height: 30),

              // Footer dengan checkbox persetujuan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE89B8E).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.verified_user,
                      color: Color(0xFFE89B8E),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Dengan menggunakan CHAMPIFY, Anda menyatakan telah membaca, memahami, dan menyetujui Syarat & Ketentuan ini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14, 
                        color: isDark ? Colors.white : Colors.black87
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terima kasih telah mempercayai CHAMPIFY sebagai partner pembelajaran Anda!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE89B8E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}