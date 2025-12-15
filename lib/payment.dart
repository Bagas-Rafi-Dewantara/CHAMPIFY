import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../main.dart'; // Akses supabase
import 'navbar.dart';

// Helper currency
String _formatCurrency(num price) {
  return price.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
}

// Helper Safe Integer
int _safeInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// ==========================================
// 1. CHECKOUT EMPTY
// ==========================================
class CheckoutEmptyPage extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final String planType;
  final double price;

  const CheckoutEmptyPage({
    super.key,
    required this.courseData,
    required this.planType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pembayaran Kelas',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Info
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: courseData['link_gambar'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            courseData['link_gambar'],
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.phone_iphone,
                          color: Colors.grey,
                          size: 30,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseData['nama_course'] ?? 'Course Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: $planType',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Method
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutFilledPage(
                      courseData: courseData,
                      planType: planType,
                      price: price,
                    ),
                  ),
                );
              },
              child: Row(
                children: const [
                  Text(
                    'Choice Payment',
                    style: TextStyle(color: Colors.orange, fontSize: 15),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 14),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price Details
            const Text(
              'Price Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Harga Kursus', 'Rp${_formatCurrency(price)}'),
            const SizedBox(height: 8),
            _buildPriceRow('Biaya Admin', 'GRATIS', isGreen: true),
            const Divider(height: 32),
            _buildPriceRow(
              'Total',
              'Rp${_formatCurrency(price)}',
              isBold: true,
              isOrange: true,
            ),
            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Silahkan pilih metode pembayaran"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isOrange = false,
    bool isGreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isOrange
                ? Colors.orange
                : (isGreen ? Colors.green : Colors.black),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. CHECKOUT FILLED
// ==========================================
class CheckoutFilledPage extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final String planType;
  final double price;

  const CheckoutFilledPage({
    super.key,
    required this.courseData,
    required this.planType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final double finalPrice = price + 8;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pembayaran Kelas',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Info
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: courseData['link_gambar'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            courseData['link_gambar'],
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.phone_iphone,
                          color: Colors.grey,
                          size: 30,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseData['nama_course'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: $planType',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Method - Selected
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'Bank Central Asia',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const Text(
                    'BCA',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price Details
            const Text(
              'Price Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Harga kursus', 'Rp${_formatCurrency(price)}'),
            const SizedBox(height: 8),
            _buildPriceRow('Biaya Admin', 'GRATIS', isGreen: true),
            const SizedBox(height: 8),
            _buildPriceRow('Kode Unik', 'Rp8'),
            const Divider(height: 32),
            _buildPriceRow(
              'Total',
              'Rp${_formatCurrency(finalPrice)}',
              isBold: true,
              isOrange: true,
            ),
            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaitingPaymentPage(
                        courseData: courseData,
                        planType: planType,
                        finalPrice: finalPrice,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89B8E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isOrange = false,
    bool isGreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isOrange
                ? Colors.orange
                : (isGreen ? Colors.green : Colors.black),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. WAITING PAYMENT
// ==========================================
class WaitingPaymentPage extends StatefulWidget {
  final Map<String, dynamic> courseData;
  final String planType;
  final double finalPrice;

  const WaitingPaymentPage({
    super.key,
    required this.courseData,
    required this.planType,
    required this.finalPrice,
  });

  @override
  State<WaitingPaymentPage> createState() => _WaitingPaymentPageState();
}

class _WaitingPaymentPageState extends State<WaitingPaymentPage> {
  bool isLoading = false;

  Future<void> _handleConfirmPayment() async {
    setState(() => isLoading = true);

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        // ... (handle user null)
        return;
      }

      // --- LOGIKA SESUAI SCHEMA DATABASE KAMU ---
      final String idPengguna = user.id;
      final int idCourse = _safeInt(widget.courseData['id_course']);

      final double price = widget.finalPrice - 8;

      // 1. Simpan ke Tabel 'transactions'
      // ... (Supabase insert ke transactions)
      await supabase.from('transactions').insert({
        'id_pengguna': idPengguna,
        'id_course': idCourse,
        'price': price,
        'admin_fee': 0,
        'total_amount': widget.finalPrice,
        // Status di-set TRUE (Sukses) karena ini adalah konfirmasi akhir
        'payment_status': true,
        'payment_date': DateTime.now().toIso8601String(),
        'tipe_paket': widget.planType,
      });

      // 2. Simpan juga ke Tabel 'mycourse'
      // Penting: Pastikan tidak ada duplikasi ID Course di mycourse
      // Supabase biasanya akan throw error jika ada constraint unique/PK duplikat.
      // Jika Anda tidak menggunakan UNIQUE constraint di mycourse (id_pengguna, id_course),
      // kode ini akan menambahkan entri baru. Asumsi Anda mengizinkan.
      await supabase.from('mycourse').insert({
        'id_pengguna': idPengguna,
        'id_course': idCourse,
      });

      // 3. Pindah ke Halaman Sukses (yg akan mengalihkan ke My Course)
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaymentSuccessPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan transaksi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Waiting for Payment',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Payment Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    'ID Pesanan',
                    'ID-${DateTime.now().millisecondsSinceEpoch}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Waktu Pesanan',
                    DateFormat('dd MMM yyyy • HH:mm').format(DateTime.now()),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Status Pesanan',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Menunggu Pembayaran',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nominal Payment
            const Text(
              'Nominal pembayaran',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Rp${_formatCurrency(widget.finalPrice)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE89B8E),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.finalPrice.toStringAsFixed(0)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nominal disalin!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bank Account (Static)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'BCA',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '943 9423 0492',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          Clipboard.setData(
                            const ClipboardData(text: '9439423492'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Rekening disalin!')),
                          );
                        },
                      ),
                    ],
                  ),

                  // --- BAGIAN TAMPILAN ATAS-BAWAH CENTER ---
                  const SizedBox(height: 12),
                  const Column(
                    children: [
                      Text(
                        'Nama Pemilik Rekening',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'PT Champify Generasi Emas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // ------------------------------------------
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price Breakdown
            const Text(
              'Rincian Harga',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Harga kursus',
              'Rp${_formatCurrency(widget.finalPrice - 8)}',
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Kode Unik', 'Rp8'),
            const Divider(height: 24),
            _buildInfoRow(
              'Total',
              'Rp${_formatCurrency(widget.finalPrice)}',
              isBold: true,
            ),
            const SizedBox(height: 24),

            // Payment Confirmation Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleConfirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89B8E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Konfirmasi Pembayaran',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center, // Center vertikal
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  // Helper untuk navigasi tombol ke Available Course (default tab Course)
  void _goToAvailableCourse(BuildContext context) {
    // Arahkan langsung ke Navbar tab Course -> My Course
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const Navbar(initialIndex: 1, initialSelectMyCourse: true),
      ),
      (route) => false,
    );
  }

  // Helper untuk navigasi tombol ke My Course (tab My Course)
  void _goToMyCourse(BuildContext context) {
    // Arahkan langsung ke Navbar tab Course -> My Course
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const Navbar(initialIndex: 1, initialSelectMyCourse: true),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- Tombol Back (Kembali ke Halaman Available Course/Main Page) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // Aksi: Kembali ke My Course (langsung ke Navbar Course)
          onPressed: () => _goToMyCourse(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Payment Successful',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('⭐', style: TextStyle(fontSize: 120)),
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // Aksi: Langsung ke My Course
                  onPressed: () => _goToMyCourse(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE89B8E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lanjut ke My Course',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
