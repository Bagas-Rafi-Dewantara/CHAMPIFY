import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mycourse_score.dart';

class MyCourseQuizPage extends StatefulWidget {
  final List<dynamic> rawQuestions;
  final int quizId;

  const MyCourseQuizPage({
    super.key,
    this.rawQuestions = const [],
    required this.quizId,
  });

  @override
  State<MyCourseQuizPage> createState() => _MyCourseQuizPageState();
}

class _MyCourseQuizPageState extends State<MyCourseQuizPage> {
  List<Map<String, dynamic>> _uiQuestions = []; // Data untuk Tampilan UI
  List<dynamic> _sortedRawData =
      []; // Data Mentah (ada pembahasan) yg sudah diurutkan

  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex; // Jawaban sementara per soal

  // 1. TAMBAHAN PENTING: List untuk menyimpan history jawaban user (0, 1, 3, etc)
  final List<int> _userAnswerHistory = [];

  int _correctCount = 0;
  bool _isHintVisible = false;

  final Color primarySalmon = const Color(0xFFFF9494);
  final Color lightSalmon = const Color(0xFFFFE0E0);

  @override
  void initState() {
    super.initState();
    _parseQuestions();
  }

  void _parseQuestions() {
    if (widget.rawQuestions.isEmpty) return;

    // Kita sort dulu raw datanya agar urutan soal konsisten
    List<dynamic> sortedList = List.from(widget.rawQuestions);
    if (sortedList.isNotEmpty &&
        sortedList[0] is Map &&
        sortedList[0].containsKey('nomor_soal')) {
      sortedList.sort(
        (a, b) => (a['nomor_soal'] ?? 0).compareTo(b['nomor_soal'] ?? 0),
      );
    }

    // Simpan raw data yang sudah urut ke variabel global class ini
    _sortedRawData = sortedList;

    setState(() {
      // Mapping untuk kebutuhan UI (Tampilan)
      _uiQuestions = sortedList.map((soal) {
        return {
          "question": soal['pertanyaan'] ?? "Pertanyaan kosong",
          "options": [
            soal['opsi_a'] ?? "-",
            soal['opsi_b'] ?? "-",
            soal['opsi_c'] ?? "-",
            soal['opsi_d'] ?? "-",
          ],
          "correctIndex": _convertKeyToIndex(soal['kunci_jawaban']),
          "hint": soal['hint'] ?? "Tidak ada hint.",
        };
      }).toList();
    });
  }

  int _convertKeyToIndex(String? key) {
    if (key == null) return 0;
    switch (key.trim().toUpperCase()) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      default:
        return 0;
    }
  }

  void _handleOptionTap(int index) {
    setState(() {
      if (_selectedAnswerIndex == index) {
        _selectedAnswerIndex = null;
      } else {
        _selectedAnswerIndex = index;
      }
    });
  }

  Future<void> _handleNextButton() async {
    if (_uiQuestions.isEmpty) return;

    if (_selectedAnswerIndex == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih jawaban dulu!")));
      return;
    }

    // 2. TAMBAHAN PENTING: Simpan jawaban user ke list history
    _userAnswerHistory.add(_selectedAnswerIndex!);

    // Hitung Score Real-time
    final currentQ = _uiQuestions[_currentQuestionIndex];
    if (_selectedAnswerIndex == currentQ['correctIndex']) {
      _correctCount++;
    }

    // Cek apakah lanjut atau finish
    if (_currentQuestionIndex < _uiQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isHintVisible = false;
      });
    } else {
      // --- KUIS SELESAI ---
      await _submitAndNavigate();
    }
  }

  // Logic Submit dipisah biar rapi
  Future<void> _submitAndNavigate() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("User tidak terdeteksi");

      final totalSoal = _uiQuestions.length;
      final scoreValue = (_correctCount / totalSoal) * 100;

      // 1. Simpan ke Database (Logic Supabase Kamu)
      final existingData = await Supabase.instance.client
          .from('quiz_score')
          .select('id_quiz_score')
          .eq('id_pengguna', userId)
          .eq('id_quiz', widget.quizId)
          .maybeSingle();

      if (existingData != null) {
        await Supabase.instance.client
            .from('quiz_score')
            .update({
              'skor': scoreValue,
              'jawaban_benar': _correctCount,
              'tanggal_pengerjaan': DateTime.now().toIso8601String(),
              'status_pengerjaan': true,
            })
            .eq('id_quiz_score', existingData['id_quiz_score']);
      } else {
        await Supabase.instance.client.from('quiz_score').insert({
          'id_pengguna': userId,
          'id_quiz': widget.quizId,
          'skor': scoreValue,
          'jawaban_benar': _correctCount,
          'tanggal_pengerjaan': DateTime.now().toIso8601String(),
          'status_pengerjaan': true,
        });
      }

      // 2. Persiapkan Data untuk Halaman Score (Review)
      // Gunakan _sortedRawData karena dia yang punya key 'pembahasan', 'opsi_a', dll.
      List<Map<String, dynamic>> processedQuestions = processDbDataForScore(
        _sortedRawData,
      );

      if (mounted) {
        Navigator.pop(context); // Tutup Loading

        // 3. Pindah Halaman
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyCourseScorePage(
              quizId: widget.quizId,
              rawQuestions: widget.rawQuestions, // Untuk Retake nanti

              totalQuestions: totalSoal,
              correctCount: _correctCount,

              // --- PASSING DATA LENGKAP ---
              questions: processedQuestions, // Data soal + pembahasan
              userAnswers: _userAnswerHistory, // History jawaban user [0, 1, 2]
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uiQuestions.isEmpty) {
      return Scaffold(
        backgroundColor: primarySalmon,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final question = _uiQuestions[_currentQuestionIndex];
    final bool isLast = _currentQuestionIndex == _uiQuestions.length - 1;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: primarySalmon,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(
              context,
            ), // Logic exit dialog kamu bisa ditaruh sini
          ),
        ),
        body: Column(
          children: [
            // ... Header Quiz Time kamu (Sama persis) ...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quiz Time",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_currentQuestionIndex + 1}/${_uiQuestions.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Putih
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / _uiQuestions.length,
                      backgroundColor: Colors.grey[200],
                      color: primarySalmon,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 30),

                    Text(
                      question['question'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.separated(
                        itemCount: (question['options'] as List).length,
                        separatorBuilder: (ctx, i) =>
                            const SizedBox(height: 15),
                        itemBuilder: (ctx, index) {
                          final option = question['options'][index];
                          final bool isSelected = _selectedAnswerIndex == index;
                          return GestureDetector(
                            onTap: () => _handleOptionTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isSelected ? lightSalmon : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? primarySalmon
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primarySalmon
                                          : Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: isSelected
                                            ? primarySalmon
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: primarySalmon,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ... Hint Logic kamu (Sama persis) ...
                    if (_isHintVisible)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: CustomPaint(
                          painter: DashedRoundedRectPainter(
                            color: const Color(0xFFFBC02D),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9C4).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              question['hint'] ?? "Tidak ada hint",
                              style: const TextStyle(color: Color(0xFFF57F17)),
                            ),
                          ),
                        ),
                      ),

                    Center(
                      child: TextButton.icon(
                        onPressed: () =>
                            setState(() => _isHintVisible = !_isHintVisible),
                        icon: Icon(
                          _isHintVisible
                              ? Icons.visibility_off
                              : Icons.lightbulb,
                          color: const Color(0xFFFBC02D),
                        ),
                        label: Text(
                          _isHintVisible ? "Close Hint" : "Need a hint?",
                          style: const TextStyle(color: Color(0xFFFBC02D)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _handleNextButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarySalmon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isLast ? "Finish Quiz" : "Next Question",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HELPER FUNCTION (Bisa ditaruh di paling bawah file) ---
List<Map<String, dynamic>> processDbDataForScore(List<dynamic> rawDbData) {
  return rawDbData.map((soal) {
    List<String> options = [
      soal['opsi_a'].toString(),
      soal['opsi_b'].toString(),
      soal['opsi_c'].toString(),
      soal['opsi_d'].toString(),
    ];

    String kunciHuruf = soal['kunci_jawaban'].toString().toUpperCase();
    int correctIndex = 0;
    if (kunciHuruf == 'B') correctIndex = 1;
    if (kunciHuruf == 'C') correctIndex = 2;
    if (kunciHuruf == 'D') correctIndex = 3;

    return {
      'question_text': soal['pertanyaan'],
      'options': options,
      'correct_index': correctIndex,
      'explanation':
          soal['pembahasan'] ?? "Tidak ada pembahasan.", // INI PENTING
    };
  }).toList();
}

// DashedRoundedRectPainter kamu tetap sama, tidak perlu diubah.
class DashedRoundedRectPainter extends CustomPainter {
  // ... Copy paste kode painter kamu sebelumnya di sini ...
  // (Isinya tidak saya tulis ulang untuk menghemat tempat, karena sudah benar)
  final double strokeWidth;
  final Color color;
  final double gap;
  final double radius;

  DashedRoundedRectPainter({
    this.strokeWidth = 1.0,
    this.color = Colors.black,
    this.gap = 5.0,
    this.radius = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    Path path = Path()..addRRect(rRect);
    Path dashedPath = Path();
    double dashWidth = 5.0;
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
