import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mycourse_quiz.dart';
import '../theme_provider.dart';

class MyCourseScorePage extends StatelessWidget {
  // Mode 1: Data detail untuk pembahasan
  final List<Map<String, dynamic>>? questions;
  final List<int>? userAnswers;

  // Mode 2: Data Summary
  final int totalQuestions;
  final int correctCount;

  // Data Wajib untuk Retake Quiz
  final int quizId;
  final List<dynamic> rawQuestions;

  const MyCourseScorePage({
    super.key,
    this.questions,
    this.userAnswers,
    required this.totalQuestions,
    required this.correctCount,
    required this.quizId,
    required this.rawQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    // 1. Hitung Score
    double score = totalQuestions > 0
        ? (correctCount / totalQuestions) * 100
        : 0;
    int wrong = totalQuestions - correctCount;

    // 2. Tentukan Warna Tema
    const Color primarySalmon = Color(0xFFFF9494);
    Color scoreColor = score >= 70
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9494);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : primarySalmon,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isDark 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.2),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context, 'close'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Quiz Result",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // --- CONTENT AREA (White Box) ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                // Ubah jadi Column agar bisa memisahkan area Scroll dan area Tombol
                child: Column(
                  children: [
                    // A. AREA SCROLL (Chart, Stats, Review)
                    Expanded(
                      child: SingleChildScrollView(
                        // PADDING DIPERKECIL (Atas 15, Bawah 10)
                        padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),

                            // 1. DONUT CHART (Score)
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 140,
                                  child: CircularProgressIndicator(
                                    value: score / 100,
                                    strokeWidth: 12,
                                    backgroundColor: isDark 
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    color: scoreColor,
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      score.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: scoreColor,
                                      ),
                                    ),
                                    Text(
                                      "Score",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDark ? Colors.grey[400] : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 25,
                            ), // Jarak diperkecil dikit
                            // 2. STATISTIK ROW
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                  "Correct",
                                  correctCount,
                                  const Color(0xFF4CAF50),
                                  Icons.check_circle_outline,
                                  isDark,
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                                ),
                                _buildStatItem(
                                  "Wrong",
                                  wrong,
                                  const Color(0xFFFF5252),
                                  Icons.highlight_off_rounded,
                                  isDark,
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),
                            Divider(color: isDark ? Colors.grey[700] : null),
                            const SizedBox(height: 15),

                            // 3. LIST REVIEW JAWABAN
                            if (questions != null && userAnswers != null) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Review Jawaban",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.grey[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: questions!.length,
                                itemBuilder: (context, index) {
                                  return _buildReviewCard(index, isDark);
                                },
                              ),
                              // Kasih jarak di bawah list biar ga nempel banget sama tombol
                              const SizedBox(height: 10),
                            ] else ...[
                              Text(
                                "Detail pembahasan tidak tersedia.",
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // B. AREA FIXED BOTTOM (Tombol)
                    Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TOMBOL 1: BACK
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, 'close');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primarySalmon,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Kembali ke Kursus",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // TOMBOL 2: RETAKE
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyCourseQuizPage(
                                      quizId: quizId,
                                      rawQuestions: rawQuestions,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFFF9494),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Retake Quiz",
                                style: TextStyle(
                                  color: Color(0xFFFF9494),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  // WIDGET HELPER: Item Statistik Kecil
  Widget _buildStatItem(String label, int value, Color color, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          "$value",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label, 
          style: TextStyle(
            fontSize: 12, 
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // WIDGET HELPER: Kartu Review Per Soal
  Widget _buildReviewCard(int index, bool isDark) {
    final question = questions![index];

    final String questionText = question['question_text'] ?? "No Question";
    final List<dynamic> options = question['options'] ?? [];
    final int correctAnswerIndex = question['correct_index'] ?? 0;
    final String explanation =
        question['explanation'] ?? "Tidak ada pembahasan untuk soal ini.";

    final int userAnswerIndex =
        (userAnswers != null && index < userAnswers!.length)
        ? userAnswers![index]
        : -1;

    final bool isCorrect = userAnswerIndex == correctAnswerIndex;
    final bool isSkipped = userAnswerIndex == -1;

    Color statusColor = isCorrect
        ? Colors.green
        : (isSkipped ? Colors.orange : Colors.red);
    String statusText = isCorrect
        ? "Benar"
        : (isSkipped ? "Dilewati" : "Salah");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Soal ${index + 1} • $statusText",
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildAnswerRow(
            "Jawaban Kamu:",
            isSkipped ? "-" : options[userAnswerIndex],
            isCorrect ? Colors.green : Colors.red,
            isDark,
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 4),
            _buildAnswerRow(
              "Jawaban Benar:",
              options[correctAnswerIndex],
              Colors.green,
              isDark,
            ),
          ],
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color(0xFF3A3A00)
                  : const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark 
                    ? const Color(0xFFFFE082)
                    : const Color(0xFFFFE082),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb, size: 16, color: Colors.orange),
                    SizedBox(width: 5),
                    Text(
                      "Pembahasan:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(String label, String answer, Color color, bool isDark) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14, 
          color: isDark ? Colors.white70 : Colors.black,
        ),
        children: [
          TextSpan(
            text: "$label ",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          TextSpan(
            text: answer,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
