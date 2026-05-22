import 'dart:async';
import 'dart:ui';
import 'dart:math'; // For random pop up coordinates
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:subakaarya/Screens/Notification_Screen.dart';
import 'package:subakaarya/Screens/Profile_Screen.dart';
import 'package:subakaarya/Screens/Decorator_Profile_Screen.dart';
import 'package:subakaarya/Screens/Explore_Screen.dart';
import 'package:subakaarya/Screens/Comments_Screen.dart';
import 'package:subakaarya/Screens/Booking_Sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

// Global notifier – any screen can fire this to jump to Bookings tab (index 2)
final ValueNotifier<int> navigateToTabNotifier = ValueNotifier<int>(-1);

// Global dark mode notifier – toggle from Settings to change entire app theme
final ValueNotifier<ThemeMode> appThemeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);


class HapticSplashFactory extends InteractiveInkFeatureFactory {
  const HapticSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    // Premium mechanical click vibration on any tap!
    HapticFeedback.lightImpact();

    return InkRipple.splashFactory.create(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      textDirection: textDirection,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Subhakarya',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFFFCFBF7),
            fontFamily: 'Roboto',
            splashFactory: const HapticSplashFactory(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: Colors.black,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.08),
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7A5405),
              secondary: Color(0xFFDCAE36),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'Roboto',
            splashFactory: const HapticSplashFactory(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1A1A),
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: Colors.white,
            ),
            cardTheme: const CardThemeData(
              color: Color(0xFF1E1E1E),
              surfaceTintColor: Color(0xFF1E1E1E),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFDCAE36),
              secondary: Color(0xFF7A5405),
              surface: Color(0xFF1E1E1E),
            ),
            dividerColor: const Color(0xFF2C2C2C),
            iconTheme: const IconThemeData(color: Colors.white70),
          ),
          home: const IntroVideoSplashScreen(),
        );
      },
    );
  }
}

class IntroVideoSplashScreen extends StatefulWidget {
  const IntroVideoSplashScreen({super.key});

  @override
  State<IntroVideoSplashScreen> createState() => _IntroVideoSplashScreenState();
}

class _IntroVideoSplashScreenState extends State<IntroVideoSplashScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Hide status bar during immersive intro video playback
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    _controller = VideoPlayerController.asset('assets/video/c_a_ebcb_c_d_mp_.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setVolume(0.0); // Mute audio
          _controller.play();
        }
      });

    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      _controller.removeListener(_videoListener);
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: _isInitialized
            ? Stack(
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDCAE36)),
                ),
              ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final ValueNotifier<bool> _isBottomNavVisibleNotifier;
  late final ValueNotifier<bool> _isCategoriesPinnedNotifier;
  int _selectedCategoryIndex = 0;
  int _currentTab = 0;
  late ScrollController _scrollController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _pageController = PageController(initialPage: _currentTab);
    _isBottomNavVisibleNotifier = ValueNotifier<bool>(true);
    _isCategoriesPinnedNotifier = ValueNotifier<bool>(false);
    _isCategoriesPinnedNotifier.addListener(_updateStatusBarTheme);
    // Listen for global tab-navigation requests (e.g. from BookingSheet)
    navigateToTabNotifier.addListener(_onNavigateToTab);
  }

  void _onNavigateToTab() {
    final tab = navigateToTabNotifier.value;
    if (tab >= 0) {
      setState(() => _currentTab = tab);
      _pageController.jumpToPage(tab);
      _isBottomNavVisibleNotifier.value = true;
      navigateToTabNotifier.value = -1; // reset
    }
  }

  void _updateStatusBarTheme() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isCategoriesPinnedNotifier.value ? Brightness.dark : Brightness.light,
    ));
  }

  @override
  void dispose() {
    navigateToTabNotifier.removeListener(_onNavigateToTab);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    _isBottomNavVisibleNotifier.dispose();
    _isCategoriesPinnedNotifier.removeListener(_updateStatusBarTheme);
    _isCategoriesPinnedNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final double offset = _scrollController.offset;
      // When the gold header above categories scrolls out, category tab bar pins.
      // 240.0 is the approximate height of branding + carousel under transparent status bar.
      const double triggerOffset = 240.0;
      if (offset > triggerOffset) {
        if (!_isCategoriesPinnedNotifier.value) {
          _isCategoriesPinnedNotifier.value = true;
        }
      } else {
        if (_isCategoriesPinnedNotifier.value) {
          _isCategoriesPinnedNotifier.value = false;
        }
      }
    }
  }

  final List<Map<String, dynamic>> _headerCategories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Marriage', 'icon': Icons.favorite_rounded},
    {'name': 'Engagement', 'icon': Icons.favorite_border_rounded},
    {'name': 'Reception', 'icon': Icons.groups_rounded},
    {'name': 'Haldi', 'icon': Icons.brush_rounded},
    {'name': 'Mehendi', 'icon': Icons.spa_rounded},
    {'name': 'Birthday', 'icon': Icons.cake_rounded},
    {'name': 'Baby Shower', 'icon': Icons.child_friendly_rounded},
    {'name': 'Housewarming', 'icon': Icons.home_work_rounded},
    {'name': 'Temple Fest', 'icon': Icons.fort_rounded},
    {'name': 'Anniversary', 'icon': Icons.stars_rounded},
    {'name': 'Catering', 'icon': Icons.restaurant_rounded},
    {'name': 'Buffet', 'icon': Icons.flatware_rounded},
    {'name': 'Decor', 'icon': Icons.celebration_rounded},
    {'name': 'Flower Decor', 'icon': Icons.yard_rounded},
    {'name': 'Lighting', 'icon': Icons.lightbulb_rounded},
    {'name': 'Stage Lights', 'icon': Icons.highlight_rounded},
    {'name': 'Photography', 'icon': Icons.camera_alt_rounded},
    {'name': 'Music & DJ', 'icon': Icons.music_note_rounded},
    {'name': 'DJ Sound', 'icon': Icons.volume_up_rounded},
    {'name': 'Invitation', 'icon': Icons.mail_rounded},
    {'name': 'Return Gifts', 'icon': Icons.card_giftcard_rounded},
    {'name': 'Planners', 'icon': Icons.assignment_turned_in_rounded},
    {'name': 'Groom Car', 'icon': Icons.directions_car_rounded},
    {'name': 'Corporate', 'icon': Icons.business_center_rounded},
    {'name': 'Exhibition', 'icon': Icons.local_mall_rounded},
    {'name': 'Puberty Fn', 'icon': Icons.brightness_high_rounded},
    {'name': 'Kids', 'icon': Icons.child_care_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background for flat flat feed cards
      body: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              // Listen globally to any vertical scroll in whichever active tab is displayed!
              if (notification.metrics.axis == Axis.vertical) {
                if (notification.direction == ScrollDirection.reverse) {
                  if (_isBottomNavVisibleNotifier.value) {
                    _isBottomNavVisibleNotifier.value = false;
                  }
                } else if (notification.direction == ScrollDirection.forward) {
                  if (!_isBottomNavVisibleNotifier.value) {
                    _isBottomNavVisibleNotifier.value = true;
                  }
                }
              }
              return false;
            },
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Tab 0: Home Feed
                CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // Scrollable immersive golden header containing address and carousel banner
                    SliverToBoxAdapter(
                      child: _buildBlinkitScrollableHeader(context),
                    ),
                    // Sticky Categories Tab Bar with dynamic background and color transition (Blinkit style!)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyCategoriesDelegate(
                        child: _buildCategoriesTabBar(context),
                        statusBarHeight: statusBarHeight,
                        isPinnedNotifier: _isCategoriesPinnedNotifier,
                      ),
                    ),
                    // Flat white body with list of event decorators (No Curves!)
                    SliverPadding(
                      // Added padding at the bottom to ensure content isn't hidden behind the floating nav bar
                      padding: const EdgeInsets.only(bottom: 100, top: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == 3) {
                              return _buildHorizontalReelsSection(context);
                            }
                            
                            // Adjust index for normal posts to account for the injected Reels section
                            final postIndex = index > 3 ? index - 1 : index;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: PostCard(
                                profileName: 'Event Decorator ${postIndex + 1}',
                                likes: '${(postIndex + 1) * 123}',
                                comments: '${(postIndex + 1) * 45}',
                                shares: '${(postIndex + 1) * 12}',
                                description: 'This is an amazing event post ${postIndex + 1} for you to book and enjoy. We offer the best services!',
                                // Pass your image URL here. I added a sample random image URL for demo.
                                imageUrl: 'https://picsum.photos/seed/${postIndex + 1}/500/300',
                                profileImageUrl: 'https://picsum.photos/seed/user${postIndex + 1}/100/100',
                              ),
                            );
                          },
                          childCount: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Tab 1: Explore View
                const ExploreScreen(isTab: true),
                
                // Tab 2: Bookings View – BookMyShow-style ticket cards
                const BookingsTabView(),
                
                // Tab 3: Profile View
                const ProfileScreen(isTab: true),
              ],
            ),
          ),
          
          // Floating Bottom Navigation Bar with isolated rebuilds via ValueNotifier
          ValueListenableBuilder<bool>(
            valueListenable: _isBottomNavVisibleNotifier,
            builder: (context, isVisible, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: isVisible ? 20 : -100,
                left: 16,
                right: 16,
                child: child!,
              );
            },
            child: _buildBottomNavigationBar(context),
          ),

        ],
      ),
    );
  }

  Widget _buildHorizontalReelsSection(BuildContext context) {
    // List of premium sample details for our dynamic reels!
    final List<Map<String, String>> reelsData = [
      {
        'imageUrl': 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=400&q=80',
        'profileUrl': 'https://picsum.photos/seed/user_r1/100/100',
        'creator': 'Zara Decor',
        'views': '124K',
        'title': 'Grand Entry Setup ✨',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?auto=format&fit=crop&w=400&q=80',
        'profileUrl': 'https://picsum.photos/seed/user_r2/100/100',
        'creator': 'Royal Weddings',
        'views': '85K',
        'title': 'Haldi Floral Shower 🌸',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=400&q=80',
        'profileUrl': 'https://picsum.photos/seed/user_r3/100/100',
        'creator': 'Stardust Events',
        'views': '210K',
        'title': 'Neon Sangeet Night 🕺',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=400&q=80',
        'profileUrl': 'https://picsum.photos/seed/user_r4/100/100',
        'creator': 'Crafty Hands',
        'views': '98K',
        'title': 'Luxury Tablescape 🍽️',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1478812954026-9c750f0e89fc?auto=format&fit=crop&w=400&q=80',
        'profileUrl': 'https://picsum.photos/seed/user_r5/100/100',
        'creator': 'Dream Planners',
        'views': '156K',
        'title': 'Fairy Canopy Lights ✨',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A5405).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Color(0xFF7A5405), // Royal Gold
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Popular Momento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2C2C2C),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          
          // Horizontal scrolling Reels List
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: reelsData.length,
              itemBuilder: (context, index) {
                final reel = reelsData[index];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreDetailScreen(
                          seed: reel['creator'] ?? 'default_seed',
                          isVideo: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 14.0),
                    child: Stack(
                      children: [
                      // Video Thumbnail image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(reel['imageUrl']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      
                      // Dark Overlay for white text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.transparent,
                                Colors.black.withOpacity(0.75),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      
                      // Frosted View Count Badge top-right
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.remove_red_eye_rounded, size: 10, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                reel['views']!,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Creator Profile and Description at the bottom
                      Positioned(
                        bottom: 12,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Creator profile row
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF7A5405), // Royal Gold
                                      width: 1.2,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(reel['profileUrl']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    reel['creator']!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Reel Description
                            Text(
                              reel['title']!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
        ),
          
          // Premium subtle divider line
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            child: Divider(
              color: Colors.grey.shade200,
              height: 1,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlinkitScrollableHeader(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF2C753), // Glowing golden yellow (Top)
            Color(0xFFDCAE36), // Vibrant golden yellow (Middle)
            Color(0xFF7A5405), // Deep rich gold (Bottom)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Glowing light ray streaks matching Blinkit exactly
          Positioned(
            top: -100,
            right: -50,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 280,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            left: 20,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 180,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Subtly lighter glowing circular spot on the top right
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF2A3).withOpacity(0.18),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Safe area spacing for transparent status bar
              SizedBox(height: statusBarHeight + 12),
              // Top Row: Branding & Address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Subakaarya branding & address
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Subhakarya',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Location Row
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Flexible(
                                  child: Text(
                                    'Madurai, Sri srinivasa nagar, Avadi',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification Button
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.white24,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationScreen(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Shifted carousel downwards
              // AutoCarouselBanner placed directly below the Search Bar
              const AutoCarouselBanner(),
              const SizedBox(height: 1), // Set gap to 1 as requested
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTabBar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isCategoriesPinnedNotifier,
        builder: (context, isPinned, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            itemCount: _headerCategories.length,
            itemBuilder: (context, index) {
              final cat = _headerCategories[index];
              final isSelected = _selectedCategoryIndex == index;
              
              Color pillColor;
              Color contentColor;
              Border? pillBorder;
              
              if (isPinned) {
                // Pinned State (White background)
                pillColor = isSelected ? const Color(0xFF7A5405) : Colors.grey.shade100;
                contentColor = isSelected ? Colors.white : const Color(0xFF555555);
                pillBorder = isSelected 
                    ? null 
                    : Border.all(color: Colors.grey.shade300, width: 1);
              } else {
                // Unpinned State (Golden background)
                pillColor = isSelected ? Colors.white : Colors.white.withOpacity(0.18);
                contentColor = isSelected ? const Color(0xFF7A5405) : Colors.white.withOpacity(0.9);
                pillBorder = isSelected 
                    ? null 
                    : Border.all(color: Colors.white.withOpacity(0.3), width: 1);
              }

              return GestureDetector(
                onTap: () {
                  if (_selectedCategoryIndex != index) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  }
                },
                child: AnimatedScale(
                  scale: isSelected ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: pillColor,
                      borderRadius: BorderRadius.circular(20),
                      border: pillBorder,
                      boxShadow: isSelected && isPinned
                          ? [
                              BoxShadow(
                                color: const Color(0xFF7A5405).withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          color: contentColor,
                          size: 15,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          cat['name'] as String,
                          style: TextStyle(
                            color: contentColor,
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
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
              _buildNavItem(Icons.home_outlined, 'Home', isActive: _currentTab == 0, onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _currentTab = 0;
                });
                _pageController.jumpToPage(0);
              }),
              _buildNavItem(Icons.explore_outlined, 'Explore', isActive: _currentTab == 1, onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _currentTab = 1;
                });
                _pageController.jumpToPage(1);
              }),
              _buildNavItem(Icons.calendar_month_outlined, 'Bookings', isActive: _currentTab == 2, onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _currentTab = 2;
                });
                _pageController.jumpToPage(2);
              }),
              _buildNavItem(Icons.person_outline, 'Profile', isActive: _currentTab == 3, onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _currentTab = 3;
                });
                _pageController.jumpToPage(3);
              }),
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

class AutoCarouselBanner extends StatefulWidget {
  const AutoCarouselBanner({super.key});

  @override
  State<AutoCarouselBanner> createState() => _AutoCarouselBannerState();
}

class _AutoCarouselBannerState extends State<AutoCarouselBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'MARRIAGE\nPACKAGE',
      'subtitle': '15% Off',
      'colors': [const Color(0xFFC2185B), const Color(0xFFF57C00)], // Vibrant Pink-Rose to Gold-Orange
      'subtitleColor': const Color(0xFFFFFF8D), // Glowing Soft Yellow
      'imageUrl': 'https://picsum.photos/seed/wedding_couple/300/300', 
      'tag': '🔥 TRENDING',
    },
    {
      'title': 'BIRTHDAY\nDECOR',
      'subtitle': '20% Off',
      'colors': [const Color(0xFFFF5722), const Color(0xFFFFC107)], // Celebratory Red-Orange to Sun Yellow
      'subtitleColor': Colors.white,
      'imageUrl': 'https://picsum.photos/seed/birthday_party/300/300',
      'tag': '🎉 DEALS',
    },
    {
      'title': 'PHOTO\nSHOOT',
      'subtitle': 'Special Deals',
      'colors': [const Color(0xFF673AB7), const Color(0xFFE91E63)], // Artistic Purple to Hot Pink
      'subtitleColor': const Color(0xFFFFFF8D), // Glowing Soft Yellow
      'imageUrl': 'https://picsum.photos/seed/photography_event/300/300',
      'tag': '✨ PREMIUM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: banner['colors'],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: banner['colors'][0].withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Image on the right
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          child: Container(
                            width: 170,
                            // Adding a subtle foreground gradient so text remains readable
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  banner['colors'][1].withOpacity(0.8),
                                  Colors.transparent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Image.network(
                              banner['imageUrl'],
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const ShimmerLoadingPlaceholder();
                              },
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.image, color: Colors.white54, size: 40),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Glassmorphic Badge
                      Positioned(
                        top: 14,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            banner['tag'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                      // Banner Text
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              banner['subtitle'],
                              style: TextStyle(
                                color: banner['subtitleColor'] ?? Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              banner['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                height: 1.0,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'serif',
                                letterSpacing: 1.2, // Adds a premium feel
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Dot Indicators (Modern Capsules)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 6,
                    width: _currentPage == index ? 20 : 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? const Color(0xFFEBC140) : Colors.white70,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Premium Shimmer Pulsing Loading Placeholder for Images
class ShimmerLoadingPlaceholder extends StatefulWidget {
  const ShimmerLoadingPlaceholder({super.key});

  @override
  State<ShimmerLoadingPlaceholder> createState() => _ShimmerLoadingPlaceholderState();
}

class _ShimmerLoadingPlaceholderState extends State<ShimmerLoadingPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.grey.shade100,
      end: Colors.grey.shade300,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          color: _colorAnimation.value,
        );
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final String profileName;
  final String likes;
  final String comments;
  final String shares;
  final String description;
  final bool isPartial;
  final String? imageUrl; // Added imageUrl parameter
  final String? profileImageUrl;

  const PostCard({
    super.key,
    required this.profileName,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.description,
    this.isPartial = false,
    this.imageUrl,
    this.profileImageUrl,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  bool isFollowing = false;
  bool isSaved = false;
  bool isLiked = false;
  late int? _likeCount;
  late AnimationController _likeController;
  late Animation<double> _likeAnimation;

  bool _showHeartOverlay = false;
  Offset? _doubleTapPosition;
  late AnimationController _heartOverlayController;
  late Animation<double> _heartScaleAnimation;
  late Animation<Offset> _heartSlideAnimation;
 
  @override
  void initState() {
    super.initState();
    _likeCount = int.tryParse(widget.likes);
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _likeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 1.4),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0),
          weight: 50,
        ),
      ],
    ).animate(CurvedAnimation(
      parent: _likeController,
      curve: Curves.easeInOut,
    ));
 
    _heartOverlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300), // Super slow, luxurious float flow
    );
    _heartScaleAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.3),
          weight: 20,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.3, end: 1.0),
          weight: 15,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 1.0),
          weight: 45, // Stays fully visible longer while floating slowly
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.0),
          weight: 20,
        ),
      ],
    ).animate(CurvedAnimation(
      parent: _heartOverlayController,
      curve: Curves.easeInOut,
    ));
 
    _heartSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.6), // Float upwards elegantly
    ).animate(CurvedAnimation(
      parent: _heartOverlayController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _likeController.dispose();
    _heartOverlayController.dispose();
    super.dispose();
  }

  void _onDoubleTapLike() {
    HapticFeedback.mediumImpact(); // Subtle haptic vibration when liked!
    
    // Generate a different random position within the image dimensions on every tap!
    final random = Random();
    final double cardWidth = MediaQuery.of(context).size.width - 32;
    
    // Random dx: between 50 and cardWidth - 50
    final double randomDx = 50.0 + random.nextDouble() * (cardWidth - 100.0);
    // Random dy: between 50 and 200 (image height is 250)
    final double randomDy = 50.0 + random.nextDouble() * 150.0;
    
    setState(() {
      _doubleTapPosition = Offset(randomDx, randomDy);
      _showHeartOverlay = true;
    });

    if (!isLiked) {
      setState(() {
        isLiked = true;
        if (_likeCount != null) _likeCount = _likeCount! + 1;
        _likeController.forward(from: 0.0);
      });
    }
    _heartOverlayController.forward(from: 0.0).then((_) {
      setState(() {
        _showHeartOverlay = false;
      });
    });
  }

  Widget _buildPremiumGradientHeart(Animation<double> animation) {
    return IgnorePointer(
      child: SlideTransition(
        position: _heartSlideAnimation,
        child: ScaleTransition(
          scale: animation,
          child: Transform.rotate(
            angle: -0.15, // Dynamic organic tilt like Instagram
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Premium Glowing Drop Shadow Behind
                const Icon(
                  Icons.favorite_rounded,
                  color: Color(0x99D50000), // Glowing deep crimson red shadow
                  size: 104, // Slightly larger backing shadow
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                // Ultra-Premium Linear-Gradient Front Heart
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFFF5252), // Premium Vibrant Coral Red
                        Color(0xFFFF1744), // Gorgeous Deep Red
                        Color(0xFFC62828), // Premium Luxurious Crimson
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DecoratorProfileScreen(
                            profileName: widget.profileName,
                            profileImageUrl: widget.profileImageUrl ?? 'https://picsum.photos/seed/${widget.profileName}/200/200',
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        // Golden story ring avatar
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF7A5405),
                                Color(0xFFDCAE36),
                                Color(0xFFFFF2A3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey.shade100,
                              backgroundImage: widget.profileImageUrl != null
                                  ? NetworkImage(widget.profileImageUrl!)
                                  : null,
                              child: widget.profileImageUrl == null
                                  ? const Icon(Icons.person, color: Colors.grey, size: 16)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.profileName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF2C2C2C),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFollowing = !isFollowing;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: isFollowing 
                              ? BoxDecoration(
                                  color: const Color(0xFF7A5405), // Theme-suitable Royal Gold filled background
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF7A5405)),
                                )
                              : BoxDecoration(
                                  color: Colors.transparent, // Hollow background to distinguish from Book Now!
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF7A5405), // Royal Gold border matching the theme!
                                    width: 1.3,
                                  ),
                                ),
                          child: Text(
                            isFollowing ? 'Unfollow' : 'Follow',
                            style: TextStyle(
                              color: isFollowing ? Colors.white : const Color(0xFF7A5405), // White text when followed, Gold text when not followed!
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Modern Rounded Save/Bookmark Button with premium touch feedback
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              isSaved = !isSaved;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isSaved ? const Color(0xFF7A5405) : const Color(0xFF2C2C2C),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Main Post Image with manual like only & shimmer loader
            GestureDetector(
              onDoubleTap: _onDoubleTapLike,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Container(
                      height: widget.isPartial ? 80 : 250,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: widget.imageUrl != null 
                          ? CachedNetworkImage(
                              imageUrl: widget.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const ShimmerLoadingPlaceholder(),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.image, color: Colors.grey, size: 40),
                            ),
                    ),
                  ),
                  // Double Tap Heart Overlay (Instagram Premium Style!)
                  if (_showHeartOverlay)
                    _doubleTapPosition != null
                        ? Positioned(
                            left: _doubleTapPosition!.dx - 50, // Centering heart at exact tap coordinate
                            top: _doubleTapPosition!.dy - 50,  // Centering heart at exact tap coordinate
                            child: _buildPremiumGradientHeart(_heartScaleAnimation),
                          )
                        : _buildPremiumGradientHeart(_heartScaleAnimation),
                ],
              ),
            ),
            // Post Footer (Only show if not partial)
            if (!widget.isPartial)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  isLiked = !isLiked;
                                  if (isLiked) {
                                    if (_likeCount != null) _likeCount = _likeCount! + 1;
                                    _likeController.forward(from: 0.0);
                                  } else {
                                    if (_likeCount != null) _likeCount = _likeCount! - 1;
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ScaleTransition(
                                  scale: _likeAnimation,
                                  child: Icon(
                                    isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    size: 26,
                                    color: isLiked ? const Color(0xFFE0245E) : const Color(0xFF2C2C2C),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _likeCount != null ? _likeCount.toString() : widget.likes,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C2C2C)),
                            ),
                            const SizedBox(width: 16),
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true, // Crucial for keyboard auto-resize inside sheets!
                                  backgroundColor: Colors.transparent, // Clip corners cleanly
                                  barrierColor: Colors.black.withOpacity(0.55), // Elegant dim overlay
                                  builder: (context) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.78, // Luxurious 78% screen coverage
                                        color: const Color(0xFFFCFBF7),
                                        child: Column(
                                          children: [
                                            // iOS Drag handle bar
                                            const SizedBox(height: 10),
                                            Container(
                                              width: 40,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF7A5405).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(2.5),
                                              ),
                                            ),
                                            const Expanded(
                                              child: CommentsScreen(autoFocus: true, showBackButton: false),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.mode_comment_outlined,
                                  size: 24,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.comments,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C2C2C)),
                            ),
                            const SizedBox(width: 16),
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.near_me_outlined,
                                  size: 26,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.shares,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C2C2C)),
                            ),
                          ],
                        ),
                        // Premium Luxury Book Now Button
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF7A5405), // Deep rich gold
                                Color(0xFFDCAE36), // Vibrant golden yellow
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7A5405).withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Book Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
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

// Custom SliverPersistentHeaderDelegate for Blinkit-style Sticky Categories Tab Bar
class _StickyCategoriesDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double statusBarHeight;
  final ValueNotifier<bool> isPinnedNotifier;

  _StickyCategoriesDelegate({
    required this.child,
    required this.statusBarHeight,
    required this.isPinnedNotifier,
  });

  @override
  double get minExtent => 50 + statusBarHeight + 20 + 24; // Added 20px bottom gold space + 24px extended white margin!

  @override
  double get maxExtent => 50 + statusBarHeight + 20 + 24; // Added 20px bottom gold space + 24px extended white margin!

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPinnedNotifier,
      builder: (context, isPinned, _) {
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Butter-smooth animation duration
              curve: Curves.easeInOut,
              height: 50 + statusBarHeight + 20, // Always constant height to eliminate scroll jumps!
              padding: EdgeInsets.only(
                top: isPinned ? statusBarHeight + 6.0 : statusBarHeight, // Smooth padding adjustment
                bottom: isPinned ? 14.0 : 20.0,
              ),
              decoration: BoxDecoration(
                color: isPinned ? Colors.white : const Color(0xFF7A5405), // Smooth background color blend!
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24.0), // Always curved bottom corners!
                ),
                boxShadow: isPinned
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  child, // The categories list (stays at same widget identity - 0% swap!)
                  
                  // Luxury calligraphy label that smoothly fades out!
                  Positioned(
                    top: -statusBarHeight,
                    left: 0,
                    right: 0,
                    height: statusBarHeight,
                    child: AnimatedOpacity(
                      opacity: isPinned ? 0.0 : 1.0, // Smooth label fade
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 1.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFFFF2A3).withOpacity(0.0),
                                    const Color(0xFFFFF2A3).withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                '✨  S E L E C T   S E R V I C E  ✨',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFFFF2A3),
                                  letterSpacing: 2.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 6,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 1.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFFFF2A3).withOpacity(0.7),
                                    const Color(0xFFFFF2A3).withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(), // Extended transparent spacer that creates a beautiful white margin!
            ),
          ],
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant _StickyCategoriesDelegate oldDelegate) {
    return oldDelegate.statusBarHeight != statusBarHeight ||
        oldDelegate.child != child; // Rebuild only if properties change
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BookingsTabView – BookMyShow-style ticket card list
// ─────────────────────────────────────────────────────────────────────────────
class BookingsTabView extends StatefulWidget {
  const BookingsTabView({super.key});

  @override
  State<BookingsTabView> createState() => _BookingsTabViewState();
}

class _BookingsTabViewState extends State<BookingsTabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    // Refresh whenever this tab becomes visible (navigateToTabNotifier fires)
    navigateToTabNotifier.addListener(_refresh);
  }

  @override
  void dispose() {
    _tabController.dispose();
    navigateToTabNotifier.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Count dynamic items of each status
    final onHoldCount = globalBookings.where((b) => b.status == 'On Hold').length;
    final onGoingCount = globalBookings.where((b) => b.status == 'On Going').length;
    final completedCount = globalBookings.where((b) => b.status == 'Completed').length;
    final cancelledCount = globalBookings.where((b) => b.status == 'Cancelled').length;

    Color getDynamicIndicatorColor() {
      if (_tabController.animation == null) {
        return const Color(0xFF7A5405);
      }
      final double value = _tabController.animation!.value;
      final colors = [
        const Color(0xFF7A5405), // Theme primary gold
        const Color(0xFF2D9CDB), // Indigo/Blue for On Going
        const Color(0xFF2ECC71), // Mild Green for Completed
        const Color(0xFFE74C3C), // Mild Red for Cancelled
      ];
      
      final double clampedValue = value.clamp(0.0, 3.0);
      final int index1 = clampedValue.floor();
      final int index2 = clampedValue.ceil();
      final double t = clampedValue - index1;
      
      return Color.lerp(colors[index1], colors[index2], t) ?? colors[index1];
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7A5405), Color(0xFFDCAE36)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Bookings',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      globalBookings.isEmpty
                          ? 'Book an event to get started!'
                          : '${globalBookings.length} total booking${globalBookings.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedBuilder(
              animation: _tabController.animation!,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  height: 46,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: getDynamicIndicatorColor(),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'On Hold ($onHoldCount)'),
                      Tab(text: 'On Going ($onGoingCount)'),
                      Tab(text: 'Completed ($completedCount)'),
                      Tab(text: 'Cancelled ($cancelledCount)'),
                    ],
                  ),
                );
              },
            ),

            // ── Tab Contents ────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildBookingsList('On Hold'),
                  _buildBookingsList('On Going'),
                  _buildBookingsList('Completed'),
                  _buildBookingsList('Cancelled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(String status) {
    final filtered = globalBookings.where((b) => b.status == status).toList();
    if (filtered.isEmpty) {
      return _buildEmptyState(status);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final globalIndex = globalBookings.indexOf(filtered[index]);
        return _TicketCard(
          booking: filtered[index],
          index: globalIndex,
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String titleText;
    String bodyText;
    IconData icon;

    if (status == 'On Hold') {
      titleText = 'No On Hold Bookings';
      bodyText = 'All booked weddings or planners are approved or completed.';
      icon = Icons.hourglass_empty_rounded;
    } else if (status == 'On Going') {
      titleText = 'No Ongoing Events';
      bodyText = 'Weddings or setups that are currently happening will show here.';
      icon = Icons.insights_rounded;
    } else if (status == 'Completed') {
      titleText = 'No Completed Events';
      bodyText = 'Your successfully organized weddings & bookings will be listed here.';
      icon = Icons.task_alt_rounded;
    } else {
      titleText = 'No Cancelled Bookings';
      bodyText = 'Clean record! You have no cancelled events.';
      icon = Icons.cancel_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF7A5405).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: const Color(0xFF7A5405),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            titleText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              bodyText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : const Color(0xFF8C8C8C),
                height: 1.5,
              ),
            ),
          ),
          if (status == 'On Hold') ...[
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                navigateToTabNotifier.value = 0; // Back to home tab
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7A5405), Color(0xFFDCAE36)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7A5405).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'Book a Venue Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Ticket Card ───────────────────────────────────────────────────────────────
class _TicketCard extends StatelessWidget {
  final BookingData booking;
  final int index;

  const _TicketCard({required this.booking, required this.index});

  String _formatDateTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  •  $h:$min $amPm';
  }

  List<Color> _getStatusColors(String status) {
    if (status == 'Completed') {
      return [const Color(0xFF2E7D32), const Color(0xFF4CAF50)]; // Mild Green
    } else if (status == 'Cancelled') {
      return [const Color(0xFFC62828), const Color(0xFFEF5350)]; // Mild Red
    } else if (status == 'On Going') {
      return [const Color(0xFF1976D2), const Color(0xFF2D9CDB)]; // Electric blue/indigo gradient
    } else {
      return [const Color(0xFF7A5405), const Color(0xFFDCAE36)]; // Theme primary gold gradient
    }
  }

  void _showFullDetails(BuildContext context) {
    HapticFeedback.mediumImpact();
    final bookingId = 'SKY${booking.bookedAt.millisecondsSinceEpoch.toString().substring(7)}';
    final colors = _getStatusColors(booking.status);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) {
        return _TicketDetailsSheet(
          booking: booking,
          primaryColor: colors[0],
          secondaryColor: colors[1],
          bookingId: bookingId,
          formatDateTime: _formatDateTime,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors(booking.status);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final holeColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    return GestureDetector(
      onTap: () => _showFullDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(isDark ? 0.3 : 0.12),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top gradient header ────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors[0], colors[1]],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.creatorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            booking.eventType,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      booking.status == 'Completed'
                          ? Icons.check_circle_rounded
                          : booking.status == 'Cancelled'
                              ? Icons.cancel_rounded
                              : booking.status == 'On Going'
                                  ? Icons.play_circle_filled_rounded
                                  : Icons.hourglass_top_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // ── Perforated tear line ───────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 16,
                  height: 32,
                  decoration: BoxDecoration(
                    color: holeColor,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        final dashCount = (constraints.maxWidth / 10).floor();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(dashCount, (_) => Container(
                            width: 5,
                            height: 1.5,
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          )),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: 16,
                  height: 32,
                  decoration: BoxDecoration(
                    color: holeColor,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  ),
                ),
              ],
            ),

            // ── Details body ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.calendar_today_rounded,   label: 'Date',    value: booking.date,          accentColor: colors[0]),
                  const SizedBox(height: 10),
                  _InfoRow(icon: Icons.access_time_rounded,      label: 'Time',    value: booking.time,          accentColor: colors[0]),
                  const SizedBox(height: 10),
                  _InfoRow(icon: Icons.person_rounded,           label: 'Guest',   value: booking.guestName,     accentColor: colors[0]),
                  
                  const SizedBox(height: 16),

                  // Beautiful Stylized QR Code Preview Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors[0].withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: colors[0].withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: CustomPaint(
                            size: const Size(42, 42),
                            painter: _QrCodePainter(
                              seed: booking.bookedAt.millisecondsSinceEpoch,
                              color: colors[0],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BOOKING QR CODE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: colors[0],
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Tap to view details',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: colors[0],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Booking ID strip
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors[0].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors[0].withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.confirmation_num_rounded, color: colors[0], size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('BOOKING ID', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: colors[0], letterSpacing: 1.2)),
                              const SizedBox(height: 2),
                              Text(
                                'SKY${booking.bookedAt.millisecondsSinceEpoch.toString().substring(7)}',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : const Color(0xFF2C2C2C), letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('BOOKED ON', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: colors[0], letterSpacing: 1.2)),
                            const SizedBox(height: 2),
                            Text(_formatDateTime(booking.bookedAt), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isDark ? Colors.white54 : const Color(0xFF6C6C6C))),
                          ],
                        ),
                      ],
                    ),
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

// ── QR Code Painter ──────────────────────────────────────────────────────────
class _QrCodePainter extends CustomPainter {
  final int seed;
  final Color color;

  _QrCodePainter({required this.seed, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double dotSize = size.width / 17; // 17x17 grid

    // Draw Position Detection Patterns (Corners)
    void drawCornerPattern(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, dotSize * 7, dotSize * 7), paint);
      final whitePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x + dotSize, y + dotSize, dotSize * 5, dotSize * 5), whitePaint);
      canvas.drawRect(Rect.fromLTWH(x + dotSize * 2, y + dotSize * 2, dotSize * 3, dotSize * 3), paint);
    }

    // Top-Left corner
    drawCornerPattern(0, 0);
    // Top-Right corner
    drawCornerPattern(size.width - dotSize * 7, 0);
    // Bottom-Left corner
    drawCornerPattern(0, size.height - dotSize * 7);

    // Seeded random dots
    int rState = seed;
    int nextRandom() {
      rState = (rState * 1103515245 + 12345) & 0x7fffffff;
      return rState;
    }

    for (int r = 0; r < 17; r++) {
      for (int c = 0; c < 17; c++) {
        // Skip corner areas
        if (r < 7 && c < 7) continue;
        if (r < 7 && c >= 10) continue;
        if (r >= 10 && c < 7) continue;

        // Skip alignment block at bottom right
        if (r >= 11 && r <= 13 && c >= 11 && c <= 13) {
          if (r == 12 && c == 12) {
            canvas.drawRect(Rect.fromLTWH(c * dotSize, r * dotSize, dotSize, dotSize), paint);
          } else if (r == 11 || r == 13 || c == 11 || c == 13) {
            canvas.drawRect(Rect.fromLTWH(c * dotSize, r * dotSize, dotSize, dotSize), paint);
          }
          continue;
        }

        if (nextRandom() % 2 == 0) {
          canvas.drawRect(Rect.fromLTWH(c * dotSize, r * dotSize, dotSize, dotSize), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrCodePainter oldDelegate) {
    return oldDelegate.seed != seed || oldDelegate.color != color;
  }
}

// ── Ticket Details Sheet ──────────────────────────────────────────────────────
class _TicketDetailsSheet extends StatelessWidget {
  final BookingData booking;
  final Color primaryColor;
  final Color secondaryColor;
  final String bookingId;
  final String Function(DateTime) formatDateTime;

  const _TicketDetailsSheet({
    required this.booking,
    required this.primaryColor,
    required this.secondaryColor,
    required this.bookingId,
    required this.formatDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget _buildDetailRow(IconData icon, String label, String value, Color themeColor) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: themeColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade500,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        margin: const EdgeInsets.only(top: 120),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),

            // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'e-Ticket Confirmation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable ticket area
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                children: [
                  // Ticket card
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top gradient header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        booking.eventType.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          booking.status == 'Cancelled'
                                              ? Icons.cancel_rounded
                                              : booking.status == 'Completed'
                                                  ? Icons.verified_rounded
                                                  : booking.status == 'On Going'
                                                      ? Icons.play_circle_filled_rounded
                                                      : Icons.hourglass_top_rounded,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          booking.status.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                booking.creatorName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Booking ID: $bookingId',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Perforated separator
                        Row(
                          children: [
                            Container(
                              width: 14,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF9F9F7),
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(14)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: LayoutBuilder(
                                  builder: (ctx, constraints) {
                                    final dashCount = (constraints.maxWidth / 8).floor();
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(dashCount, (_) => Container(
                                        width: 4,
                                        height: 1.5,
                                        color: Colors.grey.shade300,
                                      )),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: 14,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF9F9F7),
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
                              ),
                            ),
                          ],
                        ),

                        // Details Block
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(Icons.person_rounded, 'PRIMARY GUEST', booking.guestName, primaryColor),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailRow(Icons.calendar_today_rounded, 'DATE', booking.date, primaryColor),
                                  ),
                                  Expanded(
                                    child: _buildDetailRow(Icons.access_time_rounded, 'TIME', booking.time, primaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailRow(Icons.phone_rounded, 'PHONE NUMBER', booking.phone.isNotEmpty ? booking.phone : 'Not Provided', primaryColor),
                                  ),
                                  Expanded(
                                    child: _buildDetailRow(Icons.payment_rounded, 'PAYMENT METHOD', booking.paymentMethod, primaryColor),
                                  ),
                                ],
                              ),
                              if (booking.address.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                _buildDetailRow(Icons.location_on_rounded, 'VENUE ADDRESS', booking.address, primaryColor),
                              ],
                              const SizedBox(height: 16),
                              Divider(color: Colors.grey.shade100, height: 1),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailRow(Icons.people_alt_rounded, 'EXPECTED GUESTS', booking.guestCount, primaryColor),
                                  ),
                                  Expanded(
                                    child: _buildDetailRow(Icons.timelapse_rounded, 'DURATION', booking.bookingDuration, primaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailRow(Icons.restaurant_rounded, 'CATERING OPTION', booking.cateringPref, primaryColor),
                                  ),
                                  Expanded(
                                    child: _buildDetailRow(Icons.king_bed_rounded, 'ROOMS REQUIRED', booking.roomsCount, primaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Divider(color: Colors.grey.shade200, height: 1),
                              const SizedBox(height: 24),

                              // Central QR Code
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.grey.shade100, width: 1.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: CustomPaint(
                                        size: const Size(140, 140),
                                        painter: _QrCodePainter(
                                          seed: booking.bookedAt.millisecondsSinceEpoch,
                                          color: const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'SCAN TICKET AT VENUE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: primaryColor,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Booked on ${formatDateTime(booking.bookedAt)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Actions Section
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ticket saved to gallery successfully!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: Icon(Icons.download_rounded, color: primaryColor),
                          label: Text(
                            'Save Image',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryColor, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Share link generated and copied to clipboard!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.share_rounded, color: Colors.white),
                          label: const Text(
                            'Share Ticket',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
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
}

// ── Info Row Helper ───────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: accentColor, size: 15),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1.0)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFF2C2C2C))),
            ],
          ),
        ),
      ],
    );
  }
}
