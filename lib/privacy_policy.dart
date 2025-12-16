import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
            color: Colors.black,
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
                  color: const Color(0xFFE89B8E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE89B8E).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFE89B8E),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terakhir diperbarui: 16 Desember 2025',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kami menghormati privasi Anda dan berkomitmen melindungi data pribadi Anda',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _buildSection(
                number: '1',
                title: 'Informasi yang Kami Kumpulkan',
                content:
                    'Kami mengumpulkan informasi akun (nama, email, nomor telepon, tanggal lahir), profil pembelajaran (progres kursus, nilai, sertifikat), informasi pembayaran (diproses aman oleh mitra pembayaran), data perangkat (IP, tipe perangkat, OS, browser), data penggunaan (halaman yang dikunjungi, interaksi), dan komunikasi (pesan, komentar, feedback).',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '2',
                title: 'Cara Kami Menggunakan Informasi',
                content:
                    'Untuk menyediakan layanan, memproses pendaftaran dan pembayaran, personalisasi pengalaman, memberikan rekomendasi, mengirim notifikasi penting, meningkatkan kualitas layanan, mencegah penipuan, serta memenuhi kewajiban hukum.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '3',
                title: 'Pembagian Informasi',
                content:
                    'Kami tidak menjual data Anda. Informasi dapat dibagikan dengan mentor/instruktur (seperlunya), penyedia layanan (payment gateway, hosting, analytics) dengan perjanjian kerahasiaan, mitra bisnis (dengan persetujuan Anda), atau penegak hukum bila diwajibkan.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '4',
                title: 'Keamanan Data',
                content:
                    'Kami menggunakan enkripsi SSL/TLS saat transmisi, enkripsi pada database untuk data sensitif, kontrol akses terbatas, pemantauan keamanan, audit berkala, dan backup rutin. Meski begitu, tidak ada sistem yang 100% aman—jaga kerahasiaan kredensial Anda.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '5',
                title: 'Penyimpanan & Retensi Data',
                content:
                    'Data disimpan di server berlokasi di Indonesia/Singapura. Disimpan selama akun aktif dan sesuai keperluan hukum. Anda dapat meminta penghapusan; setelah penutupan akun, data dihapus/ dianonimkan dalam ~90 hari kecuali wajib disimpan untuk kepatuhan.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '6',
                title: 'Cookies & Pelacakan',
                content:
                    'Kami memakai cookies esensial (autentikasi/keamanan), fungsional (preferensi), analytics (penggunaan aplikasi), dan marketing (dengan persetujuan). Anda bisa mengatur cookies di browser; mematikan beberapa cookies dapat membatasi fungsi.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '7',
                title: 'Hak Privasi Anda',
                content:
                    'Anda berhak mengakses, mengoreksi, meminta penghapusan, membatasi pemrosesan, meminta portabilitas data, dan mengajukan keberatan atau mencabut persetujuan. Hubungi privacy@champify.com untuk menjalankan hak-hak ini.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '8',
                title: 'Privasi Anak',
                content:
                    'Layanan untuk usia 13+ tahun. Untuk usia 13-17 diperlukan izin orang tua/wali. Kami tidak sengaja mengumpulkan data anak <13; jika ditemukan, data akan dihapus.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '9',
                title: 'Marketing & Komunikasi',
                content:
                    'Kami dapat mengirim promo, newsletter, dan info kursus. Anda dapat mengubah preferensi notifikasi atau unsubscribe email marketing. Email transaksional penting tetap dikirim (mis. konfirmasi, invoice).',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '10',
                title: 'Transfer Data Internasional',
                content:
                    'Data bisa diproses di negara lain (server cloud & penyedia layanan). Kami memastikan adanya perlindungan yang sesuai. Dengan menggunakan layanan kami, Anda menyetujui transfer data ini.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '11',
                title: 'Perubahan Kebijakan',
                content:
                    'Kebijakan ini dapat diperbarui. Perubahan signifikan akan diberitahu lewat email/notifikasi. Penggunaan berlanjut berarti Anda menerima versi terbaru.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '12',
                title: 'Basis Hukum Pemrosesan',
                content:
                    'Kami memproses data berdasarkan persetujuan, pelaksanaan kontrak, kepatuhan hukum, dan kepentingan sah yang tidak mengesampingkan hak privasi Anda.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '13',
                title: 'Keamanan Pembayaran',
                content:
                    'Detail kartu tidak kami simpan. Transaksi diproses oleh payment gateway tersertifikasi (mis. Midtrans/Xendit/GoPay) menggunakan SSL dan tokenisasi. Kami hanya menyimpan informasi transaksi untuk pencatatan.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                number: '14',
                title: 'Hubungi Kami',
                content:
                    'Pertanyaan privasi: privacy@champify.com. Dukungan umum: support@champify.com. Telepon: +62 21 1234 5678. Alamat: Jl. Pendidikan No. 123, Jakarta 12345. Data Protection Officer: dpo@champify.com.',
              ),

              const SizedBox(height: 30),

              // Komitmen Privasi
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Komitmen Privasi Kami',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    _PrivacyPoint(
                      icon: Icons.lock_outline,
                      text: 'Data Anda dienkripsi dan dilindungi',
                    ),
                    SizedBox(height: 8),
                    _PrivacyPoint(
                      icon: Icons.block,
                      text: 'Kami tidak menjual data pribadi Anda',
                    ),
                    SizedBox(height: 8),
                    _PrivacyPoint(
                      icon: Icons.verified_user_outlined,
                      text: 'Anda memiliki kontrol penuh atas data Anda',
                    ),
                    SizedBox(height: 8),
                    _PrivacyPoint(
                      icon: Icons.gavel,
                      text: 'Kami mematuhi peraturan privasi yang berlaku',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE89B8E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE89B8E).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.privacy_tip, color: Color(0xFFE89B8E), size: 48),
                    SizedBox(height: 12),
                    Text(
                      'Privasi Anda adalah prioritas kami. Kami berkomitmen untuk melindungi dan menghormati data pribadi Anda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Terima kasih atas kepercayaan Anda kepada CHAMPIFY!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PrivacyPoint({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE89B8E), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}
