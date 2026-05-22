import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:subakaarya/Screens/Booking_Sheet.dart';

class DecoratorProfileScreen extends StatefulWidget {
  final String profileName;
  final String profileImageUrl;

  const DecoratorProfileScreen({
    super.key,
    required this.profileName,
    required this.profileImageUrl,
  });

  @override
  State<DecoratorProfileScreen> createState() => _DecoratorProfileScreenState();
}

class _DecoratorProfileScreenState extends State<DecoratorProfileScreen> {
  int _selectedTabIndex = 0;
  bool isFollowing = false;
  bool _isBottomNavVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.profileName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black, size: 24),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.report_outlined, color: Colors.black, size: 24),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.reverse) {
                if (_isBottomNavVisible) setState(() => _isBottomNavVisible = false);
              } else if (notification.direction == ScrollDirection.forward) {
                if (!_isBottomNavVisible) setState(() => _isBottomNavVisible = true);
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
                      const SizedBox(height: 16),
                      // Profile Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF7A5405), width: 2.5),
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundImage: NetworkImage(widget.profileImageUrl),
                                backgroundColor: Colors.grey.shade200,
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
                      const SizedBox(height: 14),
                      // Name & Bio
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.profileName.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '✨ Premium Event Decorator\n📍 Madurai, Tamil Nadu\n🎊 Marriage | Birthday | Corporate Events',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedScale(
                                scale: isFollowing ? 1.02 : 1.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutBack,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: isFollowing
                                      ? Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF7A5405),
                                                Color(0xFFA67B1E),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                HapticFeedback.selectionClick();
                                                setState(() => isFollowing = !isFollowing);
                                              },
                                              borderRadius: BorderRadius.circular(24),
                                              splashColor: Colors.white24,
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Center(
                                                  child: Text(
                                                    'Unfollow',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : OutlinedButton(
                                          onPressed: () {
                                            HapticFeedback.selectionClick();
                                            setState(() => isFollowing = !isFollowing);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(color: Color(0xFF7A5405), width: 1.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                          ),
                                          child: const Text(
                                            'Follow',
                                            style: TextStyle(
                                              color: Color(0xFF7A5405),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 150),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7A5405),
                                        Color(0xFFA67B1E),
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
                                            builder: (context) => BookingSheet(creatorName: widget.profileName),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(24),
                                      splashColor: Colors.white24,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            'Book now',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tabs
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedTabIndex = 0),
                              splashColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.transparent,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
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
                              onTap: () => setState(() => _selectedTabIndex = 1),
                              splashColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.transparent,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
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
                // Grid / Reels
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 110),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _selectedTabIndex == 0 ? 3 : 2,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                      childAspectRatio: _selectedTabIndex == 0 ? 1.0 : 0.6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _selectedTabIndex == 0
                                  ? 'https://picsum.photos/seed/dec${widget.profileName}$index/300/300'
                                  : 'https://picsum.photos/seed/reel${widget.profileName}$index/300/500',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image, color: Colors.grey),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
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
    return Container(
      height: 65,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7A5405), // Deep rich gold
            Color(0xFFA67B1E), // Mid rich gold
            Color(0xFFDCAE36), // Vibrant golden yellow
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A5405).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          }),
          _buildNavItem(Icons.explore_outlined, 'Explore'),
          _buildNavItem(Icons.calendar_month_outlined, 'Bookings'),
          _buildNavItem(Icons.person_outline, 'Profile'),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              size: isActive ? 28 : 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
