import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <--- JANGAN LUPA INI
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'mycourse_quiz.dart'; // Import halaman quiz
import 'mycourse_score.dart'; // Import halaman score

class MyCoursePlaylistPage extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const MyCoursePlaylistPage({super.key, required this.courseData});

  @override
  State<MyCoursePlaylistPage> createState() => _MyCoursePlaylistPageState();
}

class _MyCoursePlaylistPageState extends State<MyCoursePlaylistPage> {
  int selectedTabIndex = 0; // 0=Playlist, 1=Quiz, 2=Zoom
  YoutubePlayerController? _controller;
  String currentPlayingTitle = "";

  bool get isPlayerVisible => _controller != null && selectedTabIndex == 0;

  @override
  void initState() {
    super.initState();
  }

  // LOGIC TAB & VIDEO (Sama seperti sebelumnya)
  void _onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
      if (index != 0) _controller?.pause();
    });
  }

  void _playVideo(String url, String title) {
    final String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Link video tidak valid")));
      return;
    }
    setState(() {
      selectedTabIndex = 0;
      if (_controller == null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: true,
          ),
        );
      } else {
        _controller!.load(videoId);
        _controller!.play();
      }
      currentPlayingTitle = title;
    });
  }

  void _playNextVideo() {
    final List playlist = widget.courseData['playlist'] ?? [];
    playlist.sort(
      (a, b) => (a['nomor_playlist'] ?? 0).compareTo(b['nomor_playlist'] ?? 0),
    );
    int currentIndex = playlist.indexWhere(
      (video) => video['nama_playlist'] == currentPlayingTitle,
    );

    if (currentIndex != -1 && currentIndex < playlist.length - 1) {
      final nextVideo = playlist[currentIndex + 1];
      _playVideo(nextVideo['link_video'], nextVideo['nama_playlist']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ini adalah video terakhir.")),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- VIDEO PLAYER BUILDER ---
    Widget playerWidget = Container();
    if (_controller != null) {
      playerWidget = YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFFFF9494),
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller!.metadata.title.isNotEmpty
                  ? _controller!.metadata.title
                  : currentPlayingTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _playNextVideo(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9494).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      );
    }

    if (_controller == null)
      return _buildScaffold(isPlayerVisible: false, playerWidget: null);

    return YoutubePlayerBuilder(
      player: playerWidget as YoutubePlayer,
      builder: (context, player) {
        return _buildScaffold(
          isPlayerVisible: isPlayerVisible,
          playerWidget: player,
        );
      },
    );
  }

  Widget _buildScaffold({required bool isPlayerVisible, Widget? playerWidget}) {
    final String courseTitle =
        widget.courseData['nama_course'] ?? 'Course Detail';
    final String imageUrl = widget.courseData['link_gambar'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Video/Image
          SizedBox(
            height: 250,
            width: double.infinity,
            child: isPlayerVisible && playerWidget != null
                ? playerWidget
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              Container(color: const Color(0xFFFF9494)),
                        )
                      else
                        Container(color: const Color(0xFFFF9494)),
                      Container(color: Colors.black26),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.black38,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (selectedTabIndex == 0)
                        Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_circle_fill,
                              size: 70,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final List playlist =
                                  widget.courseData['playlist'] ?? [];
                              if (playlist.isNotEmpty) {
                                playlist.sort(
                                  (a, b) => (a['nomor_playlist'] ?? 0)
                                      .compareTo(b['nomor_playlist'] ?? 0),
                                );
                                _playVideo(
                                  playlist[0]['link_video'],
                                  playlist[0]['nama_playlist'],
                                );
                              }
                            },
                          ),
                        ),
                    ],
                  ),
          ),

          // Content Body
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isPlayerVisible
                            ? "Now Playing: $currentPlayingTitle"
                            : courseTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        _buildTabItem("Playlist", 0),
                        _buildTabItem("Quiz", 1),
                        _buildTabItem("Zoom", 2),
                      ],
                    ),
                  ),
                  Expanded(child: _buildContentList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    // 1. PLAYLIST
    if (selectedTabIndex == 0) {
      final List<dynamic> playlist = widget.courseData['playlist'] ?? [];
      playlist.sort(
        (a, b) =>
            (a['nomor_playlist'] ?? 0).compareTo(b['nomor_playlist'] ?? 0),
      );
      if (playlist.isEmpty)
        return const Center(child: Text("Belum ada video."));

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: playlist.length,
        itemBuilder: (context, index) {
          final video = playlist[index];
          final String title = video['nama_playlist'] ?? "Materi ${index + 1}";
          final String duration = video['durasi_video'] ?? "00:00";
          final String url = video['link_video'] ?? "";
          bool isPlaying = isPlayerVisible && (title == currentPlayingTitle);

          return GestureDetector(
            onTap: () {
              if (url.isNotEmpty) _playVideo(url, title);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isPlaying ? const Color(0xFFFFE0E0) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isPlaying
                      ? const Color(0xFFFF9494)
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: const Color(0xFFFF9494),
                    size: 40,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        Text(
                          duration,
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
            ),
          );
        },
      );
    }
    // 2. QUIZ
    else if (selectedTabIndex == 1) {
      final List<dynamic> quizzes = widget.courseData['quiz'] ?? [];
      if (quizzes.isEmpty) return const Center(child: Text("Belum ada kuis."));

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quizData = quizzes[index];
          // AMBIL DATA SOAL DARI 'soal_kuis' (Nested Data dari Supabase)
          final List<dynamic> soalList = quizData['soal_kuis'] ?? [];

          return GestureDetector(
            onTap: () async {
              if (soalList.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Soal belum tersedia.")),
                );
                return;
              }

              // --- LOGIC GATE: CEK HISTORY DULU ---
              final userId = Supabase.instance.client.auth.currentUser?.id;
              final quizId = quizData['id_quiz'];

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Anda belum login.")),
                );
                return;
              }

              // Tampilkan loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (c) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                // 1. Cek DB: Apakah user sudah pernah mengerjakan quiz ini?
                final checkData = await Supabase.instance.client
                    .from('quiz_score')
                    .select()
                    .eq('id_pengguna', userId)
                    .eq('id_quiz', quizId)
                    .maybeSingle();

                Navigator.pop(context); // Tutup loading

                if (checkData != null) {
                  // --- KASUS: SUDAH ADA DATA -> KE SCORE PAGE ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCourseScorePage(
                        totalQuestions: soalList.length,
                        correctCount: checkData['jawaban_benar'] ?? 0,
                        quizId: quizId,
                        rawQuestions: soalList,
                      ),
                    ),
                  );
                } else {
                  // --- KASUS: BELUM ADA -> KERJAIN QUIZ ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCourseQuizPage(
                        rawQuestions: soalList,
                        quizId: quizId, // PASSING ID QUIZ PENTING
                      ),
                    ),
                  );
                }
              } catch (e) {
                Navigator.pop(context); // Tutup loading jika error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal memuat data: $e")),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFA08A)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA08A).withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.assignment, color: Color(0xFFFFA08A)),
                  const SizedBox(width: 15),
                  Text(
                    "Start Quiz ${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFA08A),
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFFFFA08A),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    // 3. ZOOM
    else {
      final List<dynamic> zoomList = widget.courseData['zoom'] ?? [];
      if (zoomList.isEmpty)
        return const Center(child: Text("Belum ada jadwal zoom."));
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: zoomList.length,
        itemBuilder: (context, index) {
          final zoomItem = zoomList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.videocam_rounded,
                    color: Color(0xFF2196F3),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zoomItem['nama_zoom'] ?? "Zoom Meeting",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            zoomItem['date'] ?? "-",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 0,
                    ),
                    minimumSize: const Size(0, 35),
                  ),
                  child: const Text(
                    "Join",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isActive ? const Color(0xFFFF9494) : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
