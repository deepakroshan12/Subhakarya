import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'Explore_Screen.dart';
import 'Edit_Profile_Screen.dart';
import 'Settings_Screen.dart';
import 'Home_Screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTab;
  const ProfileScreen({super.key, this.isTab = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTabIndex = 0;
  bool isFollowing = false;
  bool _isBottomNavVisible = true;

  String _getVideoDuration(int index) {
    final list = ["0:15", "0:30", "0:45", "0:12", "0:25", "0:18", "0:20", "0:35"];
    return list[index % list.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: widget.isTab
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black, size: 20),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                },
              ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        titleSpacing: widget.isTab ? 20 : 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.settings_outlined, color: isDark ? Colors.white : Colors.black, size: 26),
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.reverse) {
                if (_isBottomNavVisible) {
                  setState(() => _isBottomNavVisible = false);
                }
              } else if (notification.direction == ScrollDirection.forward) {
                if (!_isBottomNavVisible) {
                  setState(() => _isBottomNavVisible = true);
                }
              }
              return false;
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Profile Header (Avatar and Stats)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300, width: 1),
                            ),
                            child: const CircleAvatar(
                              radius: 42,
                              backgroundImage: NetworkImage('https://picsum.photos/seed/profile_main/200/200'),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatColumn('456', 'posts'),
                                _buildStatColumn('2.5M', 'followers'),
                                _buildStatColumn('245', 'following'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Profile Name
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'DR GRAND MAHAL',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7A5405), // Deep rich gold
                                    Color(0xFFA67B1E), // Mid rich gold
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7A5405).withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EditProfileScreen(),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(24),
                                  splashColor: Colors.white24,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Color(0xFF7A5405), width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.share_outlined, color: Color(0xFF7A5405), size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'Share Profile',
                                    style: TextStyle(
                                      color: Color(0xFF7A5405),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tabs
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTabIndex = 0;
                              });
                            },
                            splashColor: Colors.grey.withOpacity(0.2),
                            highlightColor: Colors.transparent,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _selectedTabIndex == 0 ? Colors.black : Colors.transparent, 
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.collections_outlined, 
                                color: _selectedTabIndex == 0 ? Colors.black : Colors.grey.shade400, 
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTabIndex = 1;
                              });
                            },
                            splashColor: Colors.grey.withOpacity(0.2),
                            highlightColor: Colors.transparent,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _selectedTabIndex == 1 ? Colors.black : Colors.transparent, 
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.play_circle_outline, 
                                color: _selectedTabIndex == 1 ? Colors.black : Colors.grey.shade400, 
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              // Image Grid / Reels Grid
              SliverPadding(
                padding: EdgeInsets.only(bottom: widget.isTab ? 16 : 100), // Padding for BottomNavBar
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 Columns always as requested!
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    childAspectRatio: _selectedTabIndex == 0 ? 1.0 : 0.85, // Proper square/portrait layouts
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            _selectedTabIndex == 0 
                                ? 'https://picsum.photos/seed/grid$index/300/300'
                                : 'https://picsum.photos/seed/reels$index/300/500',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                          // Video Duration Badge in Videos Tab
                          if (_selectedTabIndex == 1)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 10),
                                    const SizedBox(width: 1),
                                    Text(
                                      _getVideoDuration(index),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  if (_selectedTabIndex == 0) {
                                    // Navigate to beautiful detailed post view
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePostDetailScreen(initialIndex: index),
                                      ),
                                    );
                                  } else {
                                    // Navigate to Reels list viewer
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ExploreDetailScreen(
                                          seed: 'reels$index',
                                          isVideo: true,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                splashColor: Colors.black26,
                                highlightColor: Colors.black12,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: _selectedTabIndex == 0 ? 18 : 8,
                  ),
                ),
              ),
            ],
          ),
          ),
          // Floating Bottom Navigation Bar
          if (!widget.isTab)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _isBottomNavVisible ? 20 : -100,
              left: 16,
              right: 16,
              child: _buildBottomNavigationBar(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7A5405).withOpacity(0.85),
                const Color(0xFFA67B1E).withOpacity(0.85),
                const Color(0xFFDCAE36).withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7A5405).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', isActive: false, onTap: () {
                Navigator.pop(context);
              }),
              _buildNavItem(Icons.explore_outlined, 'Explore', isActive: false, onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExploreScreen(),
                  ),
                );
              }),
              _buildNavItem(Icons.calendar_month_outlined, 'Bookings', isActive: false),
              _buildNavItem(Icons.person_outline, 'Profile', isActive: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.white24,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                size: isActive ? 26 : 22,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: isActive ? 0.3 : 0.0,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 2),
            // Glowing Indicator Dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 4,
              width: isActive ? 4 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 4,
                    spreadRadius: 1,
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

// ─────────────────────────────────────────────────────────────────────────────
// ProfilePostDetailScreen – Detailed scrolling view of profile posts
// ─────────────────────────────────────────────────────────────────────────────
class ProfilePostDetailScreen extends StatelessWidget {
  final int initialIndex;
  const ProfilePostDetailScreen({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final appBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    // Generate 18 high-fidelity matching post items
    final List<Map<String, String>> posts = List.generate(18, (index) => {
      'profileName': 'DR GRAND MAHAL',
      'profileImageUrl': 'https://picsum.photos/seed/grandmahal/100/100',
      'imageUrl': 'https://picsum.photos/seed/grid$index/600/600',
      'likes': '${180 + index * 14}',
      'comments': '${32 + index}',
      'shares': '${7 + index % 4}',
      'description': _getDesc(index),
    });

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Posts',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        controller: ScrollController(initialScrollOffset: initialIndex * 420.0),
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PostCard(
              profileName: post['profileName']!,
              profileImageUrl: post['profileImageUrl'],
              imageUrl: post['imageUrl'],
              likes: post['likes']!,
              comments: post['comments']!,
              shares: post['shares']!,
              description: post['description']!,
            ),
          );
        },
      ),
    );
  }

  String _getDesc(int index) {
    final list = [
      "Stunning gold floral decoration with absolute royal glassmorphic lighting. ✨👑",
      "Grand ceiling layout with stardust micro-chandeliers and pastel rose petals! 🌸💡",
      "Traditional brass lamps mixed with pristine white orchids for the perfect wedding entrance.",
      "Vibrant premium yellow engagement seating backdrop with beautiful hanging marigolds. 💛💐",
      "Luxurious velvet stage seating with custom light-up lettering. Truly majestic!",
    ];
    return list[index % list.length];
  }
}

