import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import '../payment.dart';
import '../main.dart';
import '../theme_provider.dart';

class DetailCoursePage extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const DetailCoursePage({super.key, required this.courseData});

  @override
  State<DetailCoursePage> createState() => _DetailCoursePageState();
}

class _DetailCoursePageState extends State<DetailCoursePage> {
  int _selectedTabIndex = 0;
  int _selectedRatingFilter = 0;
  final Color primaryColor = const Color(0xFFFF9494);

  bool _isCheckingStatus = false;

  YoutubePlayerController? _controller;
  bool _isVideoPlaying = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _handlePurchaseButton(String planType, double price) async {
    setState(() => _isCheckingStatus = true);

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silahkan login terlebih dahulu.")),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        return;
      }

      final idCourse = widget.courseData['id_course'];

      final existingPurchase = await supabase
          .from('transactions')
          .select('id_pembayaran')
          .eq('id_pengguna', user.id)
          .eq('id_course', idCourse)
          .eq('payment_status', true)
          .maybeSingle();

      if (existingPurchase != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You already bought this course!"),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutEmptyPage(
                courseData: widget.courseData,
                planType: planType,
                price: price,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error checking purchase: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
      }
    } finally {
      if (mounted) setState(() => _isCheckingStatus = false);
    }
  }

  void _playVideo(String videoUrl) {
    final String? videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (videoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Link video tidak valid")));
      return;
    }

    if (_controller != null) {
      _controller!.load(videoId);
      _controller!.play();
    } else {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
        ),
      );
    }

    setState(() {
      _isVideoPlaying = true;
    });
  }

  String _formatCurrency(num price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    final data = widget.courseData;
    final String title = data['nama_course'] ?? 'Course Detail';
    final String imageUrl = data['link_gambar'] ?? '';
    final String duration = data['durasi_course'] ?? '-';
    final int lessons = data['jumlah_lesson'] ?? 0;

    final int pricePremium = (data['harga_premium'] is int)
        ? data['harga_premium']
        : (data['harga_premium'] as double? ?? 0).toInt();
    final int priceRegular = (data['harga_reguler'] is int)
        ? data['harga_reguler']
        : (data['harga_reguler'] as double? ?? 0).toInt();

    final Map<String, dynamic>? mentorData = data['mentor'];
    final String mentorName = mentorData?['nama_mentor'] ?? "Unknown Mentor";
    final String mentorImage =
        (mentorData?['profile_picture'] != null &&
            mentorData!['profile_picture'].isNotEmpty)
        ? mentorData['profile_picture']
        : "https://i.pravatar.cc/150?img=11";
    final String mentorRole = mentorData?['deskripsi'] ?? "Expert Instructor";
    final String mentorStats = mentorData?['achivement'] ?? " ";

    final String description =
        data['deskripsi_course'] ??
        "Lorem ipsum dolor sit amet consectetur. Fusce mauris consectetur habitasse aliquam eu ante convallis eu.";

    final List<dynamic> ratingsList = data['rating'] ?? [];
    double averageRating = 0.0;
    if (ratingsList.isNotEmpty) {
      final double totalScore = ratingsList.fold(0.0, (sum, item) {
        final score = (item['rating'] is int)
            ? (item['rating'] as int).toDouble()
            : (item['rating'] as double? ?? 0.0);
        return sum + score;
      });
      averageRating = totalScore / ratingsList.length;
    }
    final String ratingDisplay = ratingsList.isEmpty
        ? "0.0/5"
        : "${averageRating.toStringAsFixed(1)}/5";

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller ?? YoutubePlayerController(initialVideoId: ""),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark 
                    ? Colors.grey[800]!.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.1),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            title: Text(
              "Course Details",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Hero Image / Video Player
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: (_isVideoPlaying && _controller != null)
                        ? YoutubePlayer(
                            controller: _controller!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: primaryColor,
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: imageUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  gradient: imageUrl.isEmpty
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF9C88FF),
                                            Color(0xFFFF9494),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final List<dynamic> playlist =
                                      widget.courseData['playlist'] ?? [];
                                  if (playlist.isNotEmpty &&
                                      playlist[0]['link_video'] != null) {
                                    _playVideo(playlist[0]['link_video']);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Tidak ada video tersedia",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFFAB9F,
                                    ).withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title & Info
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.access_time, 
                      size: 16, 
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      duration, 
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.circle, 
                      size: 4, 
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "$lessons lessons",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      ratingDisplay,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Mentor
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(mentorImage),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mentorName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            mentorRole,
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey,
                              fontSize: 10,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Colors.amber,
                          size: 24,
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Text(
                                mentorStats,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  height: 1.2,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  "Descriptions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey,
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 25),

                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildTabItem("Lessons", 0, isDark),
                    const SizedBox(width: 30),
                    _buildTabItem("Reviews", 1, isDark),
                    const SizedBox(width: 30),
                    _buildTabItem("Package details", 2, isDark),
                  ],
                ),
                const SizedBox(height: 20),

                if (_selectedTabIndex == 0) _buildLessonsList(title, isDark),
                if (_selectedTabIndex == 1) _buildReviewsList(ratingsList, isDark),
                if (_selectedTabIndex == 2) _buildPackageDetails(isDark),
                const SizedBox(height: 130),
              ],
            ),
          ),
          bottomSheet: Container(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 140,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isCheckingStatus
                        ? null
                        : () => _handlePurchaseButton(
                            'Premium',
                            pricePremium.toDouble(),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isCheckingStatus
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Premium Rp ${_formatCurrency(pricePremium)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: _isCheckingStatus
                        ? null
                        : () => _handlePurchaseButton(
                            'Regular',
                            priceRegular.toDouble(),
                          ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Regular Rp ${_formatCurrency(priceRegular)}",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonsList(String courseTitle, bool isDark) {
    final List<dynamic> rawLessons = widget.courseData['playlist'] ?? [];
    List<dynamic> sortedLessons = List.from(rawLessons);
    sortedLessons.sort((a, b) {
      int numA = a['nomor_playlist'] ?? 0;
      int numB = b['nomor_playlist'] ?? 0;
      return numA.compareTo(numB);
    });

    if (sortedLessons.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Belum ada lesson tersedia.",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      children: sortedLessons.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> lesson = entry.value;

        bool isLocked = index == 0 ? false : true;

        return InkWell(
          onTap: () {
            if (isLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Buy this package to access this video",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFFE53935),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(20),
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              if (lesson['link_video'] != null) {
                _playVideo(lesson['link_video']);
              }
            }
          },
          child: LessonItem(
            title: lesson['nama_playlist'] ?? "Untitled Lesson",
            duration: lesson['durasi_video'] ?? "00:00",
            isLocked: isLocked,
            isDark: isDark,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewsList(List<dynamic> allRatings, bool isDark) {
    final List<dynamic> filteredRatings = _selectedRatingFilter == 0
        ? allRatings
        : allRatings.where((r) {
            final int rVal = (r['rating'] is int)
                ? r['rating']
                : (r['rating'] as double).toInt();
            return rVal == _selectedRatingFilter;
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip("All Ratings", 0, isDark),
              _buildFilterChip("⭐ 5", 5, isDark),
              _buildFilterChip("⭐ 4", 4, isDark),
              _buildFilterChip("⭐ 3", 3, isDark),
              _buildFilterChip("⭐ 2", 2, isDark),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (filteredRatings.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _selectedRatingFilter == 0
                    ? "Belum ada ulasan."
                    : "Tidak ada ulasan bintang $_selectedRatingFilter.",
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
              ),
            ),
          )
        else
          ...filteredRatings.map((review) {
            final userData = review['pengguna'];
            final String name =
                userData?['full_name'] ?? userData?['username'] ?? "Pengguna";
            final String role =
                userData?['major'] ?? userData?['university'] ?? "Student";
            final String comment = review['ulasan'] ?? "";
            final int score = (review['rating'] is int)
                ? review['rating']
                : (review['rating'] as double? ?? 0).toInt();
            final String userImage =
                (userData?['profile_picture'] != null &&
                    userData!['profile_picture'].isNotEmpty)
                ? userData['profile_picture']
                : "https://i.pravatar.cc/150?img=${name.length % 70}";

            return ReviewItem(
              name: name,
              role: role,
              comment: comment,
              rating: score,
              userImageUrl: userImage,
              isDark: isDark,
            );
          }),
      ],
    );
  }

  Widget _buildPackageDetails(bool isDark) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xFF2D2D2D) 
                : const Color(0xFFFFF9C4).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Regular Benefits",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              _buildBenefitItem("Lifetime Video Access", isDark),
              _buildBenefitItem("Quiz Features", isDark),
              _buildBenefitItem("Final Project for Portfolio", isDark),
              _buildBenefitItem("E-Certificate of Completion", isDark),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF3D2D2D)
                : const Color(0xFFFFCC80).withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            gradient: isDark ? null : LinearGradient(
              colors: [
                const Color(0xFFFFCC80).withOpacity(0.3),
                const Color(0xFFFFAB91).withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Premium Benefits",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              _buildBenefitItem("All Benefits in Regular", isDark),
              _buildBenefitItem("Exclusive Mentoring Once a Week", isDark),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildBenefitItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00C853), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13, 
                color: isDark ? Colors.grey[300] : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int filterValue, bool isDark) {
    bool isSelected = _selectedRatingFilter == filterValue;
    return GestureDetector(
      onTap: () => setState(() => _selectedRatingFilter = filterValue),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFFAB91) 
              : (isDark ? const Color(0xFF2D2D2D) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFFAB91), 
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.grey[400] : const Color(0xFFFFAB91)),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index, bool isDark) {
    bool isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? const Color(0xFFFF9494)
                  : (isDark ? Colors.grey[500] : const Color(0xFFFFCCB6)),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          if (isActive)
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9494),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================
// WIDGET KECIL
// ==========================================
class LessonItem extends StatelessWidget {
  final String title;
  final String duration;
  final bool isLocked;
  final bool isDark;
  
  const LessonItem({
    super.key,
    required this.title,
    required this.duration,
    required this.isLocked,
    required this.isDark,
  });
  
  @override
  Widget build(BuildContext context) {
    const Color salmonColor = Color(0xFFFF9494);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark 
              ? Colors.grey.shade700 
              : salmonColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: isLocked
                  ? (isDark 
                      ? const Color(0xFF2D2D2D) 
                      : const Color(0xFFFFF0EB))
                  : salmonColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLocked ? Icons.lock_rounded : Icons.play_arrow_rounded,
              color: isLocked 
                  ? (isDark ? Colors.grey[600] : const Color(0xFFFFCCB6))
                  : salmonColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            duration,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[400] : Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String name;
  final String role;
  final String comment;
  final int rating;
  final String userImageUrl;
  final bool isDark;
  
  const ReviewItem({
    super.key,
    required this.name,
    required this.role,
    required this.comment,
    required this.rating,
    required this.userImageUrl,
    required this.isDark,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        // ✅ FIX: BORDER & SHADOW UNTUK LIGHT MODE
        border: isDark 
            ? Border.all(color: Colors.grey.shade800)
            : Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.shade300,
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(userImageUrl),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[300] : Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                size: 18,
                color: index < rating
                    ? const Color(0xFFFFD54F)
                    : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
