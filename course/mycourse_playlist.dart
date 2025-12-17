import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'mycourse_quiz.dart';
import 'mycourse_score.dart';

class MyCoursePlaylistPage extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const MyCoursePlaylistPage({super.key, required this.courseData});

  @override
  State<MyCoursePlaylistPage> createState() => _MyCoursePlaylistPageState();
}

class _MyCoursePlaylistPageState extends State<MyCoursePlaylistPage> {
  int selectedTabIndex = 0;
  YoutubePlayerController? _controller;
  String currentPlayingTitle = "";

  bool get isPlayerVisible => _controller != null && selectedTabIndex == 0;

  @override
  void initState() {
    super.initState();
  }

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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
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

    if (_controller == null) {
      return _buildScaffold(isPlayerVisible: false, playerWidget: null, isDark: isDark);
    }

    return YoutubePlayerBuilder(
      player: playerWidget as YoutubePlayer,
      builder: (context, player) {
        return _buildScaffold(
          isPlayerVisible: isPlayerVisible,
          playerWidget: player,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildScaffold({
    required bool isPlayerVisible, 
    Widget? playerWidget,
    required bool isDark,
  }) {
    final String courseTitle =
        widget.courseData['nama_course'] ?? 'Course Detail';
    final String imageUrl = widget.courseData['link_gambar'] ?? '';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
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
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  
                  // ✅ FIX: Tab dengan animasi instant & styling lebih jelas
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTabItem("Playlist", 0, isDark),
                        _buildTabItem("Quiz", 1, isDark),
                        _buildTabItem("Zoom", 2, isDark),
                      ],
                    ),
                  ),
                  Expanded(child: _buildContentList(isDark)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList(bool isDark) {
    if (selectedTabIndex == 0) {
      final List<dynamic> playlist = widget.courseData['playlist'] ?? [];
      playlist.sort(
        (a, b) =>
            (a['nomor_playlist'] ?? 0).compareTo(b['nomor_playlist'] ?? 0),
      );
      if (playlist.isEmpty) {
        return Center(
          child: Text(
            "Belum ada video.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        );
      }

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
                color: isPlaying 
                    ? const Color(0xFFFFE0E0) 
                    : (isDark ? const Color(0xFF2D2D2D) : Colors.white),
                borderRadius: BorderRadius.circular(18),
                // ✅ FIX: Border lebih tebal & kontras
                border: Border.all(
                  color: isPlaying
                      ? const Color(0xFFFF9494)
                      : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  width: isPlaying ? 2 : 1.5, // ✅ Border lebih tebal
                ),
                // ✅ FIX: Shadow lebih terlihat di light mode
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          maxLines: 2,
                        ),
                        Text(
                          duration,
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
            ),
          );
        },
      );
    } else if (selectedTabIndex == 1) {
      final List<dynamic> quizzes = widget.courseData['quiz'] ?? [];
      if (quizzes.isEmpty) {
        return Center(
          child: Text(
            "Belum ada kuis.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quizData = quizzes[index];
          final List<dynamic> soalList = quizData['soal_kuis'] ?? [];

          return GestureDetector(
            onTap: () async {
              if (soalList.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Soal belum tersedia.")),
                );
                return;
              }

              final userId = Supabase.instance.client.auth.currentUser?.id;
              final quizId = quizData['id_quiz'];

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Anda belum login.")),
                );
                return;
              }

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (c) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                final checkData = await Supabase.instance.client
                    .from('quiz_score')
                    .select()
                    .eq('id_pengguna', userId)
                    .eq('id_quiz', quizId)
                    .maybeSingle();

                Navigator.pop(context);

                if (checkData != null) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCourseQuizPage(
                        rawQuestions: soalList,
                        quizId: quizId,
                      ),
                    ),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal memuat data: $e")),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFFA08A),
                  width: 1.5, // ✅ Border lebih tebal
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.shade300,
                    blurRadius: 8,
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFFFFA08A),
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
    } else {
      final List<dynamic> zoomList = widget.courseData['zoom'] ?? [];
      if (zoomList.isEmpty) {
        return Center(
          child: Text(
            "Belum ada jadwal zoom.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: zoomList.length,
        itemBuilder: (context, index) {
          final zoomItem = zoomList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                width: 1.5, // ✅ Border lebih tebal
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.shade300,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            zoomItem['date'] ?? "-",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey[400] : Colors.grey,
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

  // ✅ FIX: Tab item dengan animasi INSTANT (duration 0ms) & styling lebih kontras
  Widget _buildTabItem(String title, int index, bool isDark) {
    bool isActive = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 0), // ✅ INSTANT, no animation lag
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // ✅ Active: Salmon pink background
            // ✅ Inactive: Transparent (showing parent gray background)
            color: isActive 
                ? const Color(0xFFFF9494)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            // ✅ Shadow hanya untuk active tab
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF9494).withOpacity(0.4),
                      blurRadius: 8,
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
                // ✅ Active: White text
                // ✅ Inactive: Gray text (lebih gelap untuk light mode)
                color: isActive 
                    ? Colors.white
                    : (isDark ? Colors.grey[500] : Colors.grey[600]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}