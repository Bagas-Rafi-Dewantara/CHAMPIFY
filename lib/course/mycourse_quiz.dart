import 'package:flutter/material.dart';
import 'mycourse_score.dart'; // IMPORT FILE SCORE

class MyCourseQuizPage extends StatefulWidget {
  const MyCourseQuizPage({super.key});

  @override
  State<MyCourseQuizPage> createState() => _MyCourseQuizPageState();
}

class _MyCourseQuizPageState extends State<MyCourseQuizPage> {
  // Data Soal
  final List<Map<String, dynamic>> _questions = [
    {
      "question":
          "Dalam UX Process mana yang benar dari pernyataan di bawah ini terkait kerangka kerjanya?",
      "options": [
        "Design Thinking",
        "Usability Testing",
        "Design Banner",
        "DPR",
      ],
      "correctIndex": 0,
      "explanation":
          "Design Thinking adalah kerangka kerja inovasi yang berpusat pada manusia.",
    },
    {
      "question":
          "Apa yang dimaksud dengan \"User Persona\" dalam desain UI/UX?",
      "options": [
        "Sebuah alat untuk mengukur performa aplikasi",
        "Representasi fiktif dari pengguna ideal berdasarkan riset",
        "Desain visual dari antarmuka pengguna",
        "Metode untuk menguji kegunaan produk",
      ],
      "correctIndex": 1,
      "explanation":
          "User Persona adalah karakter fiksi mewakili tipe pengguna target.",
    },
  ];

  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  final List<int> _userAnswers = []; // Simpan jawaban

  // Warna
  final Color primarySalmon = const Color(0xFFFF9494);
  final Color lightSalmon = const Color(0xFFFFE0E0);

  void _handleOptionTap(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  // Logic Navigasi Next / Finish
  Future<void> _handleNextButton() async {
    if (_selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih jawaban dulu ya!"),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    // 1. Simpan jawaban
    _userAnswers.add(_selectedAnswerIndex!);

    if (_currentQuestionIndex < _questions.length - 1) {
      // 2. Lanjut soal berikutnya
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
      });
    } else {
      // 3. Quiz Selesai -> Pindah ke Halaman SCORE
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyCourseScorePage(
            questions: _questions,
            userAnswers: _userAnswers,
          ),
        ),
      );

      // 4. Handle balikan dari halaman Score
      if (result == 'retake') {
        // Reset Quiz
        setState(() {
          _currentQuestionIndex = 0;
          _selectedAnswerIndex = null;
          _userAnswers.clear();
        });
      } else {
        // Close (Kembali ke Playlist)
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final bool isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return PopScope(
      canPop: false, // Cegah back button
      child: Scaffold(
        backgroundColor: primarySalmon,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "UI/UX – Quiz 1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Number ${_currentQuestionIndex + 1}/${_questions.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Content
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
                      // Soal
                      Text(
                        question['question'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Progress Bar
                      Row(
                        children: [
                          Expanded(
                            flex: _currentQuestionIndex + 1,
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: primarySalmon,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Expanded(
                            flex:
                                _questions.length - (_currentQuestionIndex + 1),
                            child: Container(
                              height: 6,
                              color: const Color(0xFFFDE69E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Pilihan ganda",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "20s left",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFF9494),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // List Opsi
                      Expanded(
                        child: ListView.builder(
                          itemCount: (question['options'] as List).length,
                          itemBuilder: (context, index) {
                            final optionText = question['options'][index];
                            final bool isSelected =
                                _selectedAnswerIndex == index;

                            return GestureDetector(
                              onTap: () => _handleOptionTap(index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? lightSalmon
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isSelected
                                        ? primarySalmon
                                        : const Color(0xFFFF9494),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primarySalmon
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: primarySalmon,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        optionText,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Hint Button
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: TextButton.icon(
                          onPressed: () {}, // Logic hint bisa ditambah nanti
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFFFF9C4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.lightbulb_outline,
                            color: Color(0xFFFBC02D),
                            size: 18,
                          ),
                          label: const Text(
                            "Get Hint",
                            style: TextStyle(
                              color: Color(0xFFFBC02D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Button Next/Finish
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleNextButton,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarySalmon,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLastQuestion ? "Finish" : "Continue",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
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
      ),
    );
  }
}
