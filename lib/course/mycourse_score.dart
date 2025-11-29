import 'package:flutter/material.dart';

class MyCourseScorePage extends StatelessWidget {
  // Menerima data dari halaman Quiz
  final List<Map<String, dynamic>> questions;
  final List<int> userAnswers;

  const MyCourseScorePage({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  // Fungsi hitung benar
  int _calculateCorrectAnswers() {
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i]['correctIndex']) {
        correctCount++;
      }
    }
    return correctCount;
  }

  @override
  Widget build(BuildContext context) {
    int correct = _calculateCorrectAnswers();
    int total = questions.length;
    int wrong = total - correct;
    double score = (correct / total) * 100;

    // Warna
    const Color primarySalmon = Color(0xFFFF9494);
    Color scoreColor = score >= 70
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9494);

    return Scaffold(
      backgroundColor: primarySalmon,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        // Kirim sinyal 'close' untuk kembali ke Playlist
                        Navigator.pop(context, 'close');
                      },
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

            // CONTENT AREA
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
                  children: [
                    // 1. DONUT CHART
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: correct / total,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[200],
                            color: scoreColor,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${score.toInt()}",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: scoreColor,
                              ),
                            ),
                            const Text(
                              "Score",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 2. STATISTIK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          "Correct",
                          correct,
                          const Color(0xFF4CAF50),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        _buildStatItem("Wrong", wrong, const Color(0xFFFF5252)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pembahasan Soal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 3. LIST PEMBAHASAN
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final q = questions[index];
                          final bool isUserCorrect =
                              userAnswers[index] == q['correctIndex'];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- UPDATE DI SINI (POSISI ICON PINDAH KE KANAN) ---
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 1. Text Pertanyaan (Ditaruh Kiri)
                                    Expanded(
                                      child: Text(
                                        q['question'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // 2. Icon Status (Ditaruh Kanan)
                                    Icon(
                                      isUserCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: isUserCorrect
                                          ? const Color(0xFF4CAF50)
                                          : const Color(0xFFFF5252),
                                      size:
                                          24, // Sedikit lebih besar biar jelas
                                    ),
                                  ],
                                ),

                                // ----------------------------------------------------
                                const SizedBox(height: 10),
                                // Jawaban Benar
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Correct Answer: ${q['options'][q['correctIndex']]}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Penjelasan
                                Text(
                                  q['explanation'] ?? "Tidak ada pembahasan.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // 4. RETAKE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Kirim sinyal 'retake' ke halaman Quiz
                          Navigator.pop(context, 'retake');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarySalmon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Retake Quiz",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
