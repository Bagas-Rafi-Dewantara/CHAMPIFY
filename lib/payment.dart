import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'navbar.dart';
import 'theme_provider.dart';

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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pembayaran Kelas',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontSize: 18,
          ),
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
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                  ),
                  child: courseData['link_gambar'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            courseData['link_gambar'],
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.phone_iphone,
                          color: isDark ? Colors.grey[600] : Colors.grey,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: $planType',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
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
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 13, 
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
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
              child: const Row(
                children: [
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
            Text(
              'Price Details',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Harga Kursus', 'Rp${_formatCurrency(price)}', isDark),
            const SizedBox(height: 8),
            _buildPriceRow('Biaya Admin', 'GRATIS', isDark, isGreen: true),
            Divider(height: 32, color: isDark ? Colors.grey[700] : null),
            _buildPriceRow(
              'Total',
              'Rp${_formatCurrency(price)}',
              isDark,
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
    String value,
    bool isDark, {
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
            color: isDark ? Colors.white70 : Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isOrange
                ? Colors.orange
                : (isGreen ? Colors.green : (isDark ? Colors.white : Colors.black)),
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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pembayaran Kelas',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontSize: 18,
          ),
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
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                  ),
                  child: courseData['link_gambar'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            courseData['link_gambar'],
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.phone_iphone,
                          color: isDark ? Colors.grey[600] : Colors.grey,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: $planType',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
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
            Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 13, 
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'Bank Central Asia',
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black,
                    ),
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
            Text(
              'Price Details',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Harga kursus', 'Rp${_formatCurrency(price)}', isDark),
            const SizedBox(height: 8),
            _buildPriceRow('Biaya Admin', 'GRATIS', isDark, isGreen: true),
            const SizedBox(height: 8),
            _buildPriceRow('Kode Unik', 'Rp8', isDark),
            Divider(height: 32, color: isDark ? Colors.grey[700] : null),
            _buildPriceRow(
              'Total',
              'Rp${_formatCurrency(finalPrice)}',
              isDark,
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
    String value,
    bool isDark, {
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
            color: isDark ? Colors.white70 : Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isOrange
                ? Colors.orange
                : (isGreen ? Colors.green : (isDark ? Colors.white : Colors.black)),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. WAITING PAYMENT PAGE
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
        throw Exception('User belum login');
      }

      final int idCourse = _safeInt(widget.courseData['id_course']);

      final myCourseExist = await supabase
          .from('mycourse')
          .select('id_mycourse')
          .eq('id_pengguna', user.id)
          .eq('id_course', idCourse)
          .maybeSingle();

      if (myCourseExist == null) {
        await supabase.from('mycourse').insert({
          'id_pengguna': user.id,
          'id_course': idCourse,
        });
      }

      await supabase.from('transactions').insert({
        'id_pengguna': user.id,
        'id_course': idCourse,
        'price': widget.finalPrice - 8, // harga asli tanpa kode unik
        'admin_fee': 0,
        'total_amount': widget.finalPrice,
        'payment_status': true, // true = completed
        'payment_date': DateTime.now().toIso8601String(),
        'tipe_paket': widget.planType,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Menunggu Pembayaran',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                  ),
                  child: widget.courseData['link_gambar'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.courseData['link_gambar'],
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.phone_iphone,
                          color: isDark ? Colors.grey[600] : Colors.grey,
                          size: 30,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.courseData['nama_course'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: ${widget.planType}',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Amount
            Text(
              'Nominal Transfer',
              style: TextStyle(
                fontSize: 13, 
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Rp${_formatCurrency(widget.finalPrice)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
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
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
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
                      Text(
                        '943 9423 0492',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
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
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Text(
                        'Nama Pemilik Rekening',
                        style: TextStyle(
                          fontSize: 13, 
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PT Champify Generasi Emas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price Breakdown
            Text(
              'Rincian Harga',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Harga kursus',
              'Rp${_formatCurrency(widget.finalPrice - 8)}',
              isDark,
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Kode Unik', 'Rp8', isDark),
            Divider(height: 24, color: isDark ? Colors.grey[700] : null),
            _buildInfoRow(
              'Total',
              'Rp${_formatCurrency(widget.finalPrice)}',
              isDark,
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

  Widget _buildInfoRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[400] : Colors.grey.shade700,
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
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. PAYMENT SUCCESS PAGE
// ==========================================
class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  void _goToAvailableCourse(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const Navbar(initialIndex: 1, initialSelectMyCourse: true),
      ),
      (route) => false,
    );
  }

  void _goToMyCourse(BuildContext context) {
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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => _goToMyCourse(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.yellow.shade800.withOpacity(0.3)
                      : Colors.yellow.shade100,
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