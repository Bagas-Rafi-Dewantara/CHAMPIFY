import 'package:flutter/material.dart';

// ==================== MODELS ====================

enum CompetitionStatus { onGoing, almostOver, closed, saved }

class Competition {
  final String id;
  final String title;
  final String organizer;
  final String category;
  final String prizeRange;
  final String location;
  final String startDate;
  final String endDate;
  final String imageUrl; // Nanti diisi URL internet
  final CompetitionStatus status;
  final String description;

  Competition({
    required this.id,
    required this.title,
    required this.organizer,
    required this.category,
    required this.prizeRange,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.status,
    required this.description,
  });
}

// ==================== DATA (DUMMY URL INTERNET) ====================

class CompetitionData {
  static List<Competition> getDummyCompetitions() {
    return [
      Competition(
        id: '1',
        title: 'Bahaswara',
        organizer: 'SMA Unggulan Rushd',
        category: 'SMA / Sederajat',
        prizeRange: 'Rp 60.000 - 80.000',
        location: 'Online & Jawa Timur',
        startDate: '10 Okt',
        endDate: '17 Nov 2025',
        // Pake gambar placeholder internet biar ga error
        imageUrl: 'https://images.unsplash.com/photo-1544531586-fde5298cdd40?q=80&w=200', 
        status: CompetitionStatus.almostOver,
        description:
            'Menjadi Jurnalis Kritis di Era Digital dengan Berani Bersuara. Lomba ini ditujukan untuk mengasah kemampuan jurnalistik siswa.',
      ),
      Competition(
        id: '2',
        title: 'Inovatik Astratech',
        organizer: 'Inostik politeknik Astra',
        category: 'Mahasiswa',
        prizeRange: 'Rp 25.000 - 100.000',
        location: 'Online & Jawa Tengah',
        startDate: '10 Okt',
        endDate: '12 Nov 2025',
        imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?q=80&w=200',
        status: CompetitionStatus.closed,
        description:
            'Revolusi Logistik: Menuju Digitalisasi, Keberlanjutan, dan Transformasi Bisnis dalam era modern.',
      ),
      Competition(
        id: '3',
        title: 'Essay HKI Budaya',
        organizer: 'Fakultas Hukum UNESA',
        category: 'SMA / Sederajat',
        prizeRange: 'Rp 60.000 - 80.000',
        location: 'Online & Jawa Timur',
        startDate: '10 Okt',
        endDate: '17 Nov 2025',
        imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?q=80&w=200',
        status: CompetitionStatus.onGoing,
        description: 'Hak Kekayaan Intelektual & Budaya Kontemporer. Tuangkan idemu dalam tulisan!',
      ),
      Competition(
        id: '4',
        title: 'UI/UX Design War',
        organizer: 'Google Developer',
        category: 'Umum',
        prizeRange: 'Rp 1.500.000',
        location: 'Jakarta',
        startDate: '1 Des',
        endDate: '5 Des 2025',
        imageUrl: 'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?q=80&w=200',
        status: CompetitionStatus.onGoing,
        description: 'Kompetisi desain aplikasi mobile untuk solusi permasalahan sampah di perkotaan.',
      ),
    ];
  }
}

// ==================== HELPERS ====================

class CompetitionHelper {
  static Color getStatusColor(CompetitionStatus status) {
    switch (status) {
      case CompetitionStatus.onGoing:
        return const Color(0xFF90EE90);
      case CompetitionStatus.almostOver:
        return const Color(0xFFFFF4D6);
      case CompetitionStatus.closed:
        return const Color(0xFFFFB6B6);
      case CompetitionStatus.saved:
        return Colors.blue.shade100;
    }
  }

  static String getStatusText(CompetitionStatus status) {
    switch (status) {
      case CompetitionStatus.onGoing:
        return 'On Going';
      case CompetitionStatus.almostOver:
        return 'Almost Over';
      case CompetitionStatus.closed:
        return 'Closed';
      case CompetitionStatus.saved:
        return 'Saved';
    }
  }

  static String getDescriptionTitle(String title, String statusText) {
    if (statusText == 'Closed') {
      return 'CLOSED COMPETITION';
    } else if (statusText == 'Almost Over') {
      return 'LAST CALL ${title.toUpperCase()}';
    } else {
      return 'OPEN REGISTRATION ${title.toUpperCase()}';
    }
  }
}

// ==================== SCREENS ====================

class CompetitionListScreen extends StatefulWidget {
  const CompetitionListScreen({super.key});

  @override
  State<CompetitionListScreen> createState() => _CompetitionListScreenState();
}

class _CompetitionListScreenState extends State<CompetitionListScreen> {
  CompetitionStatus? selectedFilter;
  List<Competition> savedCompetitions = [];
  List<Competition> allCompetitions = CompetitionData.getDummyCompetitions();
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Competition> getFilteredCompetitions() {
    List<Competition> competitions;
    if (selectedFilter == null) {
      competitions = allCompetitions;
    } else if (selectedFilter == CompetitionStatus.saved) {
      competitions = savedCompetitions;
    } else {
      competitions = allCompetitions
          .where((comp) => comp.status == selectedFilter)
          .toList();
    }
    
    if (searchQuery.isNotEmpty) {
      competitions = competitions.where((comp) {
        return comp.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
               comp.organizer.toLowerCase().contains(searchQuery.toLowerCase()) ||
               comp.category.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    return competitions;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCompetitions = getFilteredCompetitions();
    final showEmptyState =
        selectedFilter == CompetitionStatus.saved && savedCompetitions.isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Competition',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // 1. CAROUSEL
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: CompetitionCarousel(competitions: allCompetitions),
            ),
          ),

          // 2. STICKY HEADER
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              searchController: searchController,
              searchQuery: searchQuery,
              selectedFilter: selectedFilter,
              onSearchChanged: (value) => setState(() => searchQuery = value),
              onClearSearch: () => setState(() {
                searchController.clear();
                searchQuery = '';
              }),
              onFilterChanged: (status) => setState(() {
                selectedFilter = selectedFilter == status ? null : status;
              }),
            ),
          ),

          // 3. LIST CONTENT
          if (showEmptyState)
            SliverFillRemaining(hasScrollBody: false, child: _buildEmptyStateSaved())
          else if (filteredCompetitions.isEmpty)
            SliverFillRemaining(hasScrollBody: false, child: _buildEmptyStateNotFound())
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final competition = filteredCompetitions[index];
                  final isSaved = savedCompetitions.contains(competition);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CompetitionCard(
                      competition: competition,
                      statusColor: CompetitionHelper.getStatusColor(competition.status),
                      statusText: CompetitionHelper.getStatusText(competition.status),
                      isSaved: isSaved,
                      onSaveToggle: () {
                        setState(() {
                          if (isSaved) {
                            savedCompetitions.remove(competition);
                          } else {
                            savedCompetitions.add(competition);
                          }
                        });
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompetitionDetailScreen(
                              competition: competition,
                              isSaved: isSaved,
                              onSaveToggle: () {
                                setState(() {
                                  if (isSaved) {
                                    savedCompetitions.remove(competition);
                                  } else {
                                    savedCompetitions.add(competition);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: filteredCompetitions.length,
              ),
            ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
      // --- UPDATE NAVBAR DISINI ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // UBAH KE 3 AGAR HIGHLIGHT DI 'COMPETITION'
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,

        // Menyamakan ukuran font saat dipilih dan tidak dipilih
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // Menyamakan ukuran icon
        iconSize: 24,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle), 
            label: 'Course'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), 
            label: 'Search'
          ),
          // ITEM YANG DIUBAH: Community -> Competition
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events), // Icon Piala
            label: 'Competition'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), 
            label: 'Setting'
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateSaved() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.star, size: 100, color: Colors.yellow.shade300), SizedBox(height: 16), Text('Explore and Saved Competition first!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]));
  }

  Widget _buildEmptyStateNotFound() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search_off, size: 100, color: Colors.grey.shade300), SizedBox(height: 16), Text('No competition found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)), SizedBox(height: 8), Text('Try different keywords', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))]));
  }
}

// ==================== DELEGATES (STICKY HEADER) ====================

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final String searchQuery;
  final CompetitionStatus? selectedFilter;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final Function(CompetitionStatus) onFilterChanged;

  _StickyHeaderDelegate({
    required this.searchController,
    required this.searchQuery,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterChanged,
  });

  @override
  double get minExtent => 160;
  @override
  double get maxExtent => 160;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search competition',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(icon: Icon(Icons.clear, color: Colors.grey.shade600), onPressed: onClearSearch)
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChipWidget(label: 'Saved', isSelected: selectedFilter == CompetitionStatus.saved, onTap: () => onFilterChanged(CompetitionStatus.saved)),
                const SizedBox(width: 8),
                FilterChipWidget(label: 'All', isSelected: selectedFilter == null, onTap: () { if(selectedFilter != null) onFilterChanged(selectedFilter!); }),
                const SizedBox(width: 8),
                FilterChipWidget(label: 'On Going', isSelected: selectedFilter == CompetitionStatus.onGoing, onTap: () => onFilterChanged(CompetitionStatus.onGoing)),
                const SizedBox(width: 8),
                FilterChipWidget(label: 'Almost Over', isSelected: selectedFilter == CompetitionStatus.almostOver, onTap: () => onFilterChanged(CompetitionStatus.almostOver)),
                const SizedBox(width: 8),
                FilterChipWidget(label: 'Closed', isSelected: selectedFilter == CompetitionStatus.closed, onTap: () => onFilterChanged(CompetitionStatus.closed)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return searchQuery != oldDelegate.searchQuery || selectedFilter != oldDelegate.selectedFilter;
  }
}

// ==================== DETAIL SCREEN ====================

class CompetitionDetailScreen extends StatefulWidget {
  final Competition competition;
  final bool isSaved;
  final VoidCallback onSaveToggle;

  const CompetitionDetailScreen({
    super.key,
    required this.competition,
    required this.isSaved,
    required this.onSaveToggle,
  });

  @override
  State<CompetitionDetailScreen> createState() => _CompetitionDetailScreenState();
}

class _CompetitionDetailScreenState extends State<CompetitionDetailScreen> {
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
  }

  Color _getBackgroundColor(CompetitionStatus status) {
    switch (status) {
      case CompetitionStatus.closed: return const Color(0xFFFFA791);
      case CompetitionStatus.almostOver: return const Color(0xFFFCE7B0);
      case CompetitionStatus.onGoing: return const Color(0xFFE9FAB0);
      case CompetitionStatus.saved: return Colors.blue.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = CompetitionHelper.getStatusColor(widget.competition.status);
    final statusText = CompetitionHelper.getStatusText(widget.competition.status);
    final backgroundColor = _getBackgroundColor(widget.competition.status);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Information Competition', style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.black),
            onPressed: () {
              setState(() => _isSaved = !_isSaved);
              widget.onSaveToggle();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, -3))],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: statusText == 'Closed' ? null : () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade300, disabledBackgroundColor: Colors.grey.shade300, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
            child: Text(statusText == 'Closed' ? 'Competition Closed' : 'Register Now', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor.withOpacity(0.8), Colors.white],
            stops: const [0.0, 0.6],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16)),
                // UBAHAN: Pakai Image.network biar ga error aset
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.competition.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey.shade400)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(widget.competition.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                          child: Text(statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusText == 'Closed' ? Colors.red.shade700 : Colors.green.shade700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(children: [const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 20, color: Colors.white)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Diselenggarakan oleh', style: TextStyle(fontSize: 11, color: Colors.grey)), Text(widget.competition.organizer, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))])]),
                    const SizedBox(height: 20),
                    DetailRowWidget(icon: Icons.person, text: widget.competition.category),
                    const SizedBox(height: 12),
                    DetailRowWidget(icon: Icons.attach_money, text: widget.competition.prizeRange),
                    const SizedBox(height: 12),
                    DetailRowWidget(icon: Icons.location_on, text: widget.competition.location),
                    const SizedBox(height: 12),
                    DetailRowWidget(icon: Icons.calendar_today, text: '${widget.competition.startDate} - ${widget.competition.endDate}'),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(Icons.lightbulb, color: Colors.orange.shade700), const SizedBox(width: 8), Expanded(child: Text(CompetitionHelper.getDescriptionTitle(widget.competition.title, statusText), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange.shade700)))]),
                    const SizedBox(height: 12),
                    Text(widget.competition.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== WIDGETS LAINNYA ====================

class CompetitionCarousel extends StatefulWidget {
  final List<Competition> competitions;
  const CompetitionCarousel({super.key, required this.competitions});
  @override
  State<CompetitionCarousel> createState() => _CompetitionCarouselState();
}

class _CompetitionCarouselState extends State<CompetitionCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.55);
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }
  void _autoScroll() {
    if (!mounted) return;
    setState(() => _currentPage = (_currentPage + 1) % widget.competitions.length);
    _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemCount: widget.competitions.length,
      itemBuilder: (context, index) {
        return AnimatedScale(scale: _currentPage == index ? 1.0 : 0.9, duration: const Duration(milliseconds: 300), child: CarouselCard(competition: widget.competitions[index]));
      },
    );
  }
}

class CarouselCard extends StatelessWidget {
  final Competition competition;
  const CarouselCard({super.key, required this.competition});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // UBAHAN: Pakai Image.network
            Image.network(competition.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: Colors.grey.shade400, child: const Icon(Icons.image))),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)]))),
            Positioned(
              bottom: 20, left: 15, right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                children: [
                  Text(competition.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: CompetitionHelper.getStatusColor(competition.status).withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                    child: Text(CompetitionHelper.getStatusText(competition.status), style: TextStyle(color: CompetitionHelper.getStatusText(competition.status) == 'Closed' ? Colors.red.shade900 : Colors.green.shade900, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompetitionCard extends StatelessWidget {
  final Competition competition;
  final Color statusColor;
  final String statusText;
  final bool isSaved;
  final VoidCallback onSaveToggle;
  final VoidCallback onTap;

  const CompetitionCard({
    super.key,
    required this.competition,
    required this.statusColor,
    required this.statusText,
    required this.isSaved,
    required this.onSaveToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110, height: 140,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                  // UBAHAN: Pakai Image.network
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(competition.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => Center(child: Icon(Icons.image, size: 40, color: Colors.grey.shade400))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [const CircleAvatar(radius: 14, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 14, color: Colors.white)), const SizedBox(width: 6), Expanded(child: Text(competition.organizer, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)), GestureDetector(onTap: onSaveToggle, child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.black, size: 20))]),
                        const SizedBox(height: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)), child: Text(statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusText == 'Closed' ? Colors.red.shade700 : Colors.green.shade700))),
                        const SizedBox(height: 8),
                        Text(competition.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        InfoRowWidget(icon: Icons.person, text: competition.category, compact: true),
                        const SizedBox(height: 4),
                        InfoRowWidget(icon: Icons.attach_money, text: competition.prizeRange, compact: true),
                        const SizedBox(height: 4),
                        InfoRowWidget(icon: Icons.location_on, text: competition.location, compact: true),
                        const SizedBox(height: 4),
                        InfoRowWidget(icon: Icons.calendar_today, text: '${competition.startDate} - ${competition.endDate}', compact: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity, height: 45,
                child: ElevatedButton(onPressed: statusText == 'Closed' ? null : () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade300, disabledBackgroundColor: Colors.grey.shade300, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: Text(statusText == 'Closed' ? 'Competition Closed' : 'Register Now', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label; final bool isSelected; final VoidCallback onTap;
  const FilterChipWidget({super.key, required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: isSelected ? Colors.orange.shade300 : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? Colors.orange.shade300 : Colors.grey.shade300)), child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal))));
  }
}

class InfoRowWidget extends StatelessWidget {
  final IconData icon; final String text; final bool compact;
  const InfoRowWidget({super.key, required this.icon, required this.text, this.compact = false});
  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon, size: compact ? 13 : 16, color: Colors.orange.shade300), SizedBox(width: compact ? 6 : 8), Expanded(child: Text(text, style: TextStyle(fontSize: compact ? 11 : 13, color: Colors.grey.shade700), maxLines: 1, overflow: TextOverflow.ellipsis))]);
  }
}

class DetailRowWidget extends StatelessWidget {
  final IconData icon; final String text;
  const DetailRowWidget({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: Colors.orange.shade700)), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)))]);
  }
}