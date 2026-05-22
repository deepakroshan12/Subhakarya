import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Seed data for Recent Searches
  List<String> _recentSearches = [
    'Traditional Mandap Decor',
    'Fairy lights canopy',
    'Modern stage background',
    'Floral bridal entry',
  ];

  // Seed data for Trending Mahals
  final List<Map<String, String>> _trendingMahals = [
    {
      'name': 'DR Grand Mahal & Gardens',
      'location': 'Chennai, ECR',
      'rating': '4.9',
      'imageUrl': 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=300&q=80',
    },
    {
      'name': 'Royal Palace Convention Centre',
      'location': 'Chennai, OMR',
      'rating': '4.8',
      'imageUrl': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=300&q=80',
    },
    {
      'name': 'Lotus Gardens & Palace',
      'location': 'Chennai, Anna Nagar',
      'rating': '4.7',
      'imageUrl': 'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?auto=format&fit=crop&w=300&q=80',
    },
  ];

  // Seed data for Popular Searches
  final List<String> _popularSuggestions = [
    'Stage decorations for reception',
    'Bridal entry canopy concepts',
    'Outdoor garden night wedding',
    'Minimalist pastel flower walls',
    'Birthday party balloon backdrops',
  ];

  @override
  void initState() {
    super.initState();
    // Auto focus search bar when entering page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFBF7), // Warm premium canvas
        appBar: AppBar(
          backgroundColor: const Color(0xFFFCFBF7),
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 48,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2C2C2C), size: 20),
              splashRadius: 22,
              onPressed: () {
                // Haptic feedback handled automatically by splashFactory, but let's reinforce it
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
              },
            ),
          ),
          title: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEFECE6), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF7A5405), // Royal Gold
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: const TextStyle(
                      color: Color(0xFF2C2C2C),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search decorators, mahals, staging...',
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (value) {
                      final val = value.trim();
                      if (val.isNotEmpty) {
                        setState(() {
                          if (!_recentSearches.contains(val)) {
                            _recentSearches.insert(0, val);
                          }
                          _searchController.clear();
                        });
                      }
                    },
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.clear_rounded, color: Colors.grey, size: 18),
                    ),
                  ),
              ],
            ),
          ),
          titleSpacing: 8,
          actions: const [
            SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Recent Searches Section
                if (_recentSearches.isNotEmpty) ...[
                  _buildSectionHeader('Recent Searches', showClearAll: true),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recentSearches.map((search) => _buildRecentTag(search)).toList(),
                  ),
                  const SizedBox(height: 28),
                ],

                // 2. Trending Mahals Section
                _buildSectionHeader('Trending Mahals'),
                const SizedBox(height: 14),
                _buildTrendingMahalsList(),
                const SizedBox(height: 28),

                // 3. Popular Searches Section
                _buildSectionHeader('Popular Suggestions'),
                const SizedBox(height: 12),
                _buildPopularSuggestionsList(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showClearAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFF7A5405), // Royal Gold Tag
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2C2C2C),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        if (showClearAll)
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _recentSearches.clear();
              });
            },
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Color(0xFF7A5405),
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentTag(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF7A5405).withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7A5405).withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _searchController.text = text;
              _searchFocusNode.requestFocus();
            },
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF7A5405),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _recentSearches.remove(text);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xFF7A5405),
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingMahalsList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _trendingMahals.length,
        itemBuilder: (context, index) {
          final mahal = _trendingMahals[index];
          return Container(
            width: 240,
            margin: const EdgeInsets.only(right: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEFECE6), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    mahal['imageUrl']!,
                    fit: BoxFit.cover,
                  ),
                  // Bottom Text Backdrop Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.85),
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  // Rating tag
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A5405),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFF2A3), size: 13),
                          const SizedBox(width: 4),
                          Text(
                            mahal['rating']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Info panel
                  Positioned(
                    bottom: 12,
                    left: 14,
                    right: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mahal['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: const Color(0xFFDCAE36).withOpacity(0.8), size: 12),
                            const SizedBox(width: 4),
                            Text(
                              mahal['location']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularSuggestionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _popularSuggestions.length,
      separatorBuilder: (context, index) => const Divider(color: Color(0xFFEFECE6), height: 1),
      itemBuilder: (context, index) {
        final suggestion = _popularSuggestions[index];
        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _searchController.text = suggestion;
            _searchFocusNode.requestFocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF7A5405), // Royal Gold
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
